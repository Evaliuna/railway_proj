from flask import Flask, render_template, request, redirect, url_for, flash
import mysql.connector
from mysql.connector import Error
from datetime import datetime
from decimal import Decimal

app = Flask(__name__)
app.secret_key = 'railway_secret_key'

# --- DATABASE CONFIG ---
# ⚠️ UPDATE YOUR PASSWORD HERE
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '',  # Add your MySQL password here
    'database': 'railway_db'
}

def get_db_connection():
    """Helper function to connect to MySQL with error handling"""
    try:
        return mysql.connector.connect(**db_config)
    except Error as e:
        print(f"DB Connection Error: {e}")
        return None

# ============================================
# ROUTE: Home Page - Show Available Schedules
# ============================================
@app.route('/')
def index():
    """Home: Show Available Schedules with Seat Availability Logic"""
    conn = get_db_connection()
    if not conn:
        return "Database Connection Failed", 500
    
    cursor = conn.cursor(dictionary=True, buffered=True)
    
    try:
        query = """
            SELECT 
                s.ScheduleID, t.TrainName, t.TrainNumber, t.TotalSeats,
                r.SourceStation, r.DestinationStation, s.DepartureTime,
                f.TotalAmount, f.ClassType,
                COUNT(b.TicketID) as BookedSeats
            FROM SCHEDULES s
            JOIN TRAINS t ON s.TrainNumber = t.TrainNumber
            JOIN ROUTES r ON s.RouteID = r.RouteID
            JOIN FARES f ON r.RouteID = f.RouteID
            LEFT JOIN BOOKINGS b ON s.ScheduleID = b.ScheduleID AND b.SeatStatus = 'Confirmed'
            GROUP BY s.ScheduleID, f.FareID
            ORDER BY s.DepartureTime ASC
        """
        cursor.execute(query)
        schedules = cursor.fetchall()
        
        for schedule in schedules:
            schedule['AvailableSeats'] = schedule['TotalSeats'] - schedule['BookedSeats']
        
        return render_template('index.html', schedules=schedules)
    finally:
        cursor.close()
        conn.close()
# ============================================
# ROUTE: About Us Page
# ============================================
@app.route('/about')
def about():
    """About Us page showing team information"""
    return render_template('about.html')
# ============================================
# ROUTE: Book Ticket Page
# ============================================
@app.route('/book/<int:schedule_id>', methods=['GET', 'POST'])
def book_ticket(schedule_id):
    """Handle ticket booking with passenger, booking, and payment creation"""
    conn = get_db_connection()
    if not conn:
        return "Database Connection Failed", 500
    
    cursor = conn.cursor(dictionary=True, buffered=True)

    if request.method == 'POST':
        fullname = request.form['fullname']
        dob = request.form['dob']
        gender = request.form['gender']
        passport = request.form['passport']
        payment_method = request.form['payment_method']

        try:
            # 1. Get Fare Amount and Train Info
            cursor.execute("""
                SELECT f.TotalAmount, s.TrainNumber, f.FareID
                FROM SCHEDULES s
                JOIN FARES f ON s.RouteID = f.RouteID
                WHERE s.ScheduleID = %s
            """, (schedule_id,))
            fare_info = cursor.fetchone()
            
            if not fare_info:
                flash('Schedule not found!', 'danger')
                return redirect(url_for('index'))
                
            amount = fare_info['TotalAmount']
            
            # 2. Get or Create Guest User
            cursor.execute("SELECT UserID FROM USERS WHERE Username = 'guest_user'")
            user_result = cursor.fetchone()
            
            if user_result:
                user_id = user_result['UserID']
            else:
                cursor.execute("""
                    INSERT INTO USERS (Username, PasswordHash, Email, FullName, Role)
                    VALUES ('guest_user', 'guest', 'guest@railway.com', 'Guest User', 'Passenger')
                """)
                conn.commit()
                user_id = cursor.lastrowid

            # 3. Insert Passenger
            cursor.execute("""
                INSERT INTO PASSENGERS (UserID, PassportNumber, FullName, DateOfBirth, Gender)
                VALUES (%s, %s, %s, %s, %s)
            """, (user_id, passport, fullname, dob, gender))
            passenger_id = cursor.lastrowid

            # 4. Insert Booking
            booking_date = datetime.now()
            cursor.execute("""
                INSERT INTO BOOKINGS (PassengerID, ScheduleID, BookingDate, SeatStatus, DynamicPricingFactor)
                VALUES (%s, %s, %s, 'Confirmed', 1.00)
            """, (passenger_id, schedule_id, booking_date))
            ticket_id = cursor.lastrowid

            # 5. Insert Payment
            cursor.execute("""
                INSERT INTO PAYMENTS (TicketID, Amount, PaymentDate, Method)
                VALUES (%s, %s, %s, %s)
            """, (ticket_id, amount, booking_date, payment_method))

            conn.commit()
            flash(f'Ticket Booked Successfully! Ticket ID: {ticket_id}', 'success')
            return redirect(url_for('view_bookings'))

        except Error as e:
            conn.rollback()
            flash(f'Booking Failed: {str(e)}', 'danger')
            return redirect(url_for('book_ticket', schedule_id=schedule_id))
        finally:
            cursor.close()
            conn.close()

    # GET Request: Show Booking Form
    try:
        cursor.execute("""
            SELECT t.TrainName, t.TrainNumber, r.SourceStation, r.DestinationStation, 
                   s.DepartureTime, s.ArrivalTime, f.TotalAmount, f.ClassType
            FROM SCHEDULES s
            JOIN TRAINS t ON s.TrainNumber = t.TrainNumber
            JOIN ROUTES r ON s.RouteID = r.RouteID
            JOIN FARES f ON r.RouteID = f.RouteID
            WHERE s.ScheduleID = %s
        """, (schedule_id,))
        schedule_details = cursor.fetchone()
        
        if not schedule_details:
            flash('Schedule not found!', 'danger')
            return redirect(url_for('index'))
            
        return render_template('book.html', schedule=schedule_details, schedule_id=schedule_id)
    finally:
        cursor.close()
        conn.close()

# ============================================
# ROUTE: View All Bookings
# ============================================
@app.route('/bookings')
def view_bookings():
    """View All Bookings"""
    conn = get_db_connection()
    if not conn:
        return "Database Connection Failed", 500
    
    cursor = conn.cursor(dictionary=True, buffered=True)
    
    try:
        query = """
            SELECT b.TicketID, p.FullName, t.TrainName, r.SourceStation, r.DestinationStation, 
                   b.BookingDate, b.SeatStatus, pay.Amount, pay.Method
            FROM BOOKINGS b
            JOIN PASSENGERS p ON b.PassengerID = p.PassengerID
            JOIN SCHEDULES s ON b.ScheduleID = s.ScheduleID
            JOIN TRAINS t ON s.TrainNumber = t.TrainNumber
            JOIN ROUTES r ON s.RouteID = r.RouteID
            JOIN PAYMENTS pay ON b.TicketID = pay.TicketID
            ORDER BY b.TicketID DESC
        """
        cursor.execute(query)
        bookings = cursor.fetchall()
        return render_template('bookings.html', bookings=bookings)
    finally:
        cursor.close()
        conn.close()

# ============================================
# ROUTE: User Registration (Optional)
# ============================================
@app.route('/register', methods=['GET', 'POST'])
def register():
    """Optional user registration - no login required"""
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']
        fullname = request.form['fullname']
        
        conn = get_db_connection()
        if not conn:
            flash('Database connection failed!', 'danger')
            return redirect(url_for('register'))
        
        cursor = conn.cursor(dictionary=True, buffered=True)
        
        try:
            cursor.execute("SELECT UserID FROM USERS WHERE Username = %s", (username,))
            if cursor.fetchone():
                flash('Username already exists! Please choose another.', 'warning')
                return redirect(url_for('register'))
            
            if email:
                cursor.execute("SELECT UserID FROM USERS WHERE Email = %s", (email,))
                if cursor.fetchone():
                    flash('Email already registered!', 'warning')
                    return redirect(url_for('register'))
            
            cursor.execute("""
                INSERT INTO USERS (Username, PasswordHash, Email, FullName, Role)
                VALUES (%s, %s, %s, %s, 'Passenger')
            """, (username, password, email if email else None, fullname))
            
            conn.commit()
            flash(f'Registration successful! Welcome, {fullname}!', 'success')
            return redirect(url_for('index'))
            
        except Error as e:
            conn.rollback()
            flash(f'Registration failed: {str(e)}', 'danger')
            return redirect(url_for('register'))
        finally:
            cursor.close()
            conn.close()
    
    return render_template('register.html')

# ============================================
# ROUTE: Cancel Ticket (ONLY ONE DEFINITION)
# ============================================
@app.route('/cancel/<int:ticket_id>')
def cancel_ticket(ticket_id):
    """Handle Cancellation and Refund Logic"""
    conn = get_db_connection()
    if not conn:
        return "Database Connection Failed", 500
    
    cursor = conn.cursor(dictionary=True, buffered=True)
    
    try:
        # 1. Check if ticket exists and is not already cancelled
        cursor.execute("SELECT SeatStatus FROM BOOKINGS WHERE TicketID = %s", (ticket_id,))
        status_result = cursor.fetchone()
        
        if not status_result:
            flash('Ticket not found!', 'danger')
            return redirect(url_for('view_bookings'))
            
        if status_result['SeatStatus'] == 'Cancelled':
            flash('Ticket already cancelled!', 'warning')
            return redirect(url_for('view_bookings'))

        # 2. Get Amount for Refund
        cursor.execute("SELECT Amount FROM PAYMENTS WHERE TicketID = %s", (ticket_id,))
        payment_result = cursor.fetchone()
        
        if not payment_result:
            flash('Payment record not found!', 'danger')
            return redirect(url_for('view_bookings'))
            
        amount = payment_result['Amount']

        # 3. Insert Cancellation Record
        cursor.execute("""
            INSERT INTO CANCELLATIONS (TicketID, CancellationDate, Reason)
            VALUES (%s, %s, %s)
        """, (ticket_id, datetime.now(), 'User Request'))
        cancellation_id = cursor.lastrowid

        # 4. Insert Refund Record (90% refund policy)
        # FIX: Handle Decimal type properly
        if isinstance(amount, Decimal):
            refund_amount = amount * Decimal('0.90')
        else:
            refund_amount = float(amount) * 0.90
            
        cursor.execute("""
            INSERT INTO REFUNDS (CancellationID, RefundAmount, Status)
            VALUES (%s, %s, %s)
        """, (cancellation_id, refund_amount, 'Processed'))

        # 5. Update Booking Status to Cancelled
        cursor.execute("UPDATE BOOKINGS SET SeatStatus = 'Cancelled' WHERE TicketID = %s", (ticket_id,))
        
        conn.commit()
        flash(f'Ticket Cancelled! Refund of ${float(refund_amount):.2f} will be processed.', 'success')
        
    except Error as e:
        conn.rollback()
        flash(f'Cancellation Error: {str(e)}', 'danger')
    finally:
        cursor.close()
        conn.close()
        
    return redirect(url_for('view_bookings'))

# ============================================
# RUN APPLICATION
# ============================================
if __name__ == '__main__':
    app.run(debug=True, port=5000)