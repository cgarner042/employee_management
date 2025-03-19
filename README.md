## Features

1. **Employee Management**:
   - Store employee details such as name, email, phone, position, department, and manager.
   - Track employee start dates, activity status, and timestamps for record creation and updates.
2. **Employee Family Information**:
   - Store information about employees' family members, including names, relationships, and additional details.
3. **Employee Preferences**:
   - Track employee preferences for praise and accountability methods.
4. **Employee Evaluations**:
   - Record employee evaluations, including strengths, areas for improvement, aspirations, and notes.
   - Track who conducted the evaluation.
5. **Problem and Solution Tracking**:
   - Identify and track problems within the organization, including who identified the problem and who is most affected.
   - Propose and track solutions to problems, including implementation status and success ratings.
6. **Promotions**:
   - Track employee promotions, including previous and new positions, promotion dates, and notes.
7. **Monthly Contributions**:
   - Track monthly employee contributions, including problems identified, solutions proposed, and solutions implemented.
8. **Performance Views**:
   - **EmployeePerformanceSummary**: Provides a summary of employee performance, including problems identified, solutions proposed, solutions implemented, and promotions.
   - **MonthlyPerformance**: Provides a monthly performance report for each employee.
   - **ProblemResolutionTimes**: Calculates the time taken to resolve each problem.
9. **Indexes**:
   - Indexes are created on frequently queried columns to improve database performance.
10. **User Permissions**:
    - Two user roles are created: `manager` and `viewer`.
    - The `manager` has full access to the database.
    - The `viewer` has read-only access to non-sensitive tables.

## Database Schema

### Tables

1. **Employees**:
   - Stores employee details.
   - Includes a self-referencing foreign key for managers.
2. **EmployeeFamily**:
   - Stores family member details for employees.
3. **EmployeePreferences**:
   - Stores employee preferences.
4. **EmployeeEvaluations**:
   - Stores employee evaluation records.
5. **Problems**:
   - Tracks identified problems.
6. **Solutions**:
   - Tracks proposed and implemented solutions.
7. **Promotions**:
   - Tracks employee promotions.
8. **Contributions**:
   - Tracks monthly employee contributions.

### Views

1. **EmployeePerformanceSummary**:
   - Summarizes employee performance metrics.
2. **MonthlyPerformance**:
   - Provides monthly performance data for employees.
3. **ProblemResolutionTimes**:
   - Calculates the time taken to resolve problems.

### Indexes

- Indexes are created on:
  - `Employees(name)`
  - `Problems(status)`
  - `Solutions(implementation_status)`

### User Roles

1. **Manager**:
   - Has full access to the database.
   - Can perform CRUD operations on all tables.
2. **Viewer**:
   - Has read-only access to non-sensitive tables (`Employees`, `Problems`, `Solutions`).
   - Access to sensitive tables (`EmployeeFamily`, `EmployeeEvaluations`) is revoked.

## Technologies Used

- **MySQL**: The database management system used to store and manage all data.
- **SQL**: The language used to define the database schema, create views, and manage user permissions.

## Setup Instructions

1. **Install MySQL**:

   - Ensure MySQL is installed on your system. You can download it from the [official MySQL website](https://dev.mysql.com/downloads/).

2. **Run the SQL Script**:

   - Open MySQL Command Line Client or any MySQL GUI tool (e.g., MySQL Workbench).
   - Execute the provided SQL script to create the database, tables, views, indexes, and users.

   ```bash
   mysql -u root -p < employee_management.sql
   ```

3. **Verify the Setup**:

   - Log in to MySQL and verify that the `employee_management` database and its tables have been created.
   - Check that the `manager` and `viewer` users have been created with the correct permissions.

4. **Access the Database**:

   - Use the `manager` user for full access or the `viewer` user for read-only access.

## Example Queries

- **Retrieve Employee Performance Summary**:
  ```sql
  SELECT * FROM EmployeePerformanceSummary;
  ```

- **View Monthly Performance**:
  ```sql
  SELECT * FROM MonthlyPerformance;
  ```

- **Check Problem Resolution Times**:
  ```sql
  SELECT * FROM ProblemResolutionTimes;
  ```

## Security Considerations

- Sensitive tables (`EmployeeFamily`, `EmployeeEvaluations`) are restricted to the `manager` role.
- The `viewer` role has limited access to ensure data privacy.

## Future Enhancements

1. **Advanced Reporting**:
   - Add more detailed reports for employee performance and problem resolution.
2. **Audit Logs**:
   - Implement audit logs to track changes made to the database.
3. **Integration with HR Systems**:
   - Integrate with external HR systems for seamless data synchronization.
4. **User Interface**:
   - Develop a web-based or desktop interface for easier interaction with the database.

## License

This project is licensed under the **MIT License**. See the [LICENSE](https://license/) file for details.