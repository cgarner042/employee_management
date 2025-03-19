CREATE DATABASE employee_management;
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    date_started DATE NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    position VARCHAR(100),
    department VARCHAR(100),
    manager_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (manager_id) REFERENCES Employees(employee_id)
);
CREATE TABLE EmployeeFamily (
    family_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    family_member_name VARCHAR(100),
    relationship VARCHAR(50),
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);
CREATE TABLE EmployeePreferences (
    preference_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    preferred_praise_methods TEXT,
    preferred_accountability_methods TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);
CREATE TABLE EmployeeEvaluations (
    evaluation_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    evaluation_date DATE NOT NULL,
    strengths TEXT,
    areas_for_improvement TEXT,
    aspirations TEXT,
    notes TEXT,
    evaluated_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (evaluated_by) REFERENCES Employees(employee_id)
);
CREATE TABLE Problems (
    problem_id INT PRIMARY KEY AUTO_INCREMENT,
    description TEXT NOT NULL,
    identified_by INT NOT NULL,
    affected_most INT,
    variables_to_consider TEXT,
    status ENUM('identified', 'in_progress', 'solved', 'abandoned') DEFAULT 'identified',
    priority ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
    date_identified DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (identified_by) REFERENCES Employees(employee_id),
    FOREIGN KEY (affected_most) REFERENCES Employees(employee_id)
);
CREATE TABLE Solutions (
    solution_id INT PRIMARY KEY AUTO_INCREMENT,
    problem_id INT NOT NULL,
    description TEXT NOT NULL,
    proposed_by INT NOT NULL,
    implementation_status ENUM('proposed', 'approved', 'in_progress', 'implemented', 'rejected') DEFAULT 'proposed',
    date_proposed DATE NOT NULL,
    date_implemented DATE,
    success_rating INT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (problem_id) REFERENCES Problems(problem_id),
    FOREIGN KEY (proposed_by) REFERENCES Employees(employee_id)
);
CREATE TABLE Promotions (
    promotion_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    previous_position VARCHAR(100),
    new_position VARCHAR(100) NOT NULL,
    promotion_date DATE NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);
CREATE TABLE Contributions (
    contribution_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    month DATE NOT NULL,
    problems_identified INT DEFAULT 0,
    solutions_proposed INT DEFAULT 0,
    solutions_implemented INT DEFAULT 0,
    other_contributions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);
CREATE VIEW EmployeePerformanceSummary AS
SELECT 
    e.employee_id,
    e.name,
    e.position,
    e.date_started,
    COUNT(DISTINCT p.problem_id) AS problems_identified,
    COUNT(DISTINCT s.solution_id) AS solutions_proposed,
    COUNT(DISTINCT CASE WHEN s.implementation_status = 'implemented' THEN s.solution_id END) AS solutions_implemented,
    COUNT(DISTINCT pr.promotion_id) AS promotions_count
FROM 
    Employees e
LEFT JOIN Problems p ON e.employee_id = p.identified_by
LEFT JOIN Solutions s ON e.employee_id = s.proposed_by
LEFT JOIN Promotions pr ON e.employee_id = pr.employee_id
GROUP BY e.employee_id;
-- Example indexes
CREATE INDEX idx_employee_name ON Employees(name);
CREATE INDEX idx_problem_status ON Problems(status);
CREATE INDEX idx_solution_implementation ON Solutions(implementation_status);
-- Create users with appropriate permissions
CREATE USER 'manager'@'localhost' IDENTIFIED BY 'strong_password';
CREATE USER 'viewer'@'localhost' IDENTIFIED BY 'different_password';

-- Grant permissions
GRANT ALL PRIVILEGES ON employee_management.* TO 'manager'@'localhost';
GRANT SELECT ON employee_management.Employees TO 'viewer'@'localhost';
GRANT SELECT ON employee_management.Problems TO 'viewer'@'localhost';
GRANT SELECT ON employee_management.Solutions TO 'viewer'@'localhost';

-- Deny access to sensitive tables
REVOKE ALL PRIVILEGES ON employee_management.EmployeeFamily FROM 'viewer'@'localhost';
REVOKE ALL PRIVILEGES ON employee_management.EmployeeEvaluations FROM 'viewer'@'localhost';
-- Monthly performance report
CREATE VIEW MonthlyPerformance AS
SELECT 
    e.name,
    DATE_FORMAT(c.month, '%Y-%m') as month,
    c.problems_identified,
    c.solutions_proposed,
    c.solutions_implemented
FROM Employees e
JOIN Contributions c ON e.employee_id = c.employee_id
ORDER BY e.name, c.month;

-- Problem resolution times
CREATE VIEW ProblemResolutionTimes AS
SELECT
    p.problem_id,
    p.description,
    p.date_identified,
    MIN(CASE WHEN s.implementation_status = 'implemented' THEN s.date_implemented END) as date_solved,
    DATEDIFF(
        MIN(CASE WHEN s.implementation_status = 'implemented' THEN s.date_implemented END),
        p.date_identified
    ) as days_to_resolve
FROM Problems p
LEFT JOIN Solutions s ON p.problem_id = s.problem_id
GROUP BY p.problem_id;