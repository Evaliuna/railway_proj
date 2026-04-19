# Railway Reservation Management System (RRMS)

A Flask-based web application for managing railway reservations. This system allows users to view available train schedules, book tickets, manage their bookings, and process cancellations with refunds.

## Features

- **View Train Schedules**: Check available trains, their routes, departure/arrival times, and seat availability.
- **Book Tickets**: Book tickets for available schedules. The system automatically handles user creation (including guest users), passenger details, booking records, and payment processing.
- **View Bookings**: See a list of all your booked tickets along with passenger, train, routing, and payment details.
- **User Registration**: Create an account to manage your bookings (optional).
- **Cancel Tickets**: Cancel bookings and automatically calculate and process refunds (e.g., 90% refund policy).

## Technology Stack

- **Backend**: Python, Flask
- **Database**: MySQL (using `mysql-connector-python`)
- **Frontend**: HTML , CSS  (Flask `render_template`)

## Setup Instructions

1. **Clone the repository** (or navigate to the project directory):
   ```bash
   cd RRMS
   ```

2. **Create a virtual environment (optional but recommended)**:
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows use: .\.venv\Scripts\activate
   ```

3. **Install the dependencies**:
   Ensure you have the required packages installed.
   ```bash
   pip install -r requirements.txt
   ```

4. **Database Configuration**:
   - Ensure you have a MySQL server running locally.
   - Run the provided `db_setup.sql` script to create the necessary database (`railway_db`) and tables.
   - Open `app.py` and update the `db_config` dictionary with your MySQL credentials, especially your password:
     ```python
     db_config = {
         'host': 'localhost',
         'user': 'root',
         'password': 'YOUR_MYSQL_PASSWORD',
         'database': 'railway_db'
     }
     ```

5. **Run the Application**:
   Start the Flask development server:
   ```bash
   python app.py
   ```

6. **Access the Application**:
   Open your web browser and navigate to `http://127.0.0.1:5000` (or the port specified in the terminal output).
