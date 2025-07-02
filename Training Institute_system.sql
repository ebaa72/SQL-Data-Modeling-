create database Training Institute_system:

use Training Institute_system:

-- Table: Trainee
CREATE TABLE Trainee (
    trainee_id INT PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(10),
    email VARCHAR(100),
    background VARCHAR(100)
);

-- Table: Trainer
CREATE TABLE Trainer (
    trainer_id INT PRIMARY KEY,
    name VARCHAR(100),
    specialty VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100)
);

-- Table: Course
CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    title VARCHAR(100),
    category VARCHAR(50),
    duration_hours INT,
    level VARCHAR(20)
);

-- Table: Schedule
CREATE TABLE Schedule (
    schedule_id INT PRIMARY KEY,
    course_id INT,
    trainer_id INT,
    start_date DATE,
    end_date DATE,
    time_slot VARCHAR(20),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (trainer_id) REFERENCES Trainer(trainer_id)
);

-- Table: Enrollment
CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY,
    trainee_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (trainee_id) REFERENCES Trainee(trainee_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);


-- Trainees
INSERT INTO Trainee VALUES 
(1, 'Aisha Al-Harthy', 'Female', 'aisha@example.com', 'Engineering'),
(2, 'Sultan Al-Farsi', 'Male', 'sultan@example.com', 'Business'),
(3, 'Mariam Al-Saadi', 'Female', 'mariam@example.com', 'Marketing'),
(4, 'Omar Al-Balushi', 'Male', 'omar@example.com', 'Computer Science'),
(5, 'Fatma Al-Hinai', 'Female', 'fatma@example.com', 'Data Science');

-- Trainers
INSERT INTO Trainer VALUES 
(1, 'Khalid Al-Maawali', 'Databases', '96891234567', 'khalid@example.com'),
(2, 'Noura Al-Kindi', 'Web Development', '96892345678', 'noura@example.com'),
(3, 'Salim Al-Harthy', 'Data Science', '96893456789', 'salim@example.com');

-- Courses
INSERT INTO Course VALUES 
(1, 'Database Fundamentals', 'Databases', 20, 'Beginner'),
(2, 'Web Development Basics', 'Web', 30, 'Beginner'),
(3, 'Data Science Introduction', 'Data Science', 25, 'Intermediate'),
(4, 'Advanced SQL Queries', 'Databases', 15, 'Advanced');

-- Schedule
INSERT INTO Schedule VALUES 
(1, 1, 1, '2025-07-01', '2025-07-10', 'Morning'),
(2, 2, 2, '2025-07-05', '2025-07-20', 'Evening'),
(3, 3, 3, '2025-07-10', '2025-07-25', 'Weekend'),
(4, 4, 1, '2025-07-15', '2025-07-22', 'Morning');

-- Enrollments
INSERT INTO Enrollment VALUES 
(1, 1, 1, '2025-06-01'),
(2, 2, 1, '2025-06-02'),
(3, 3, 2, '2025-06-03'),
(4, 4, 3, '2025-06-04'),
(5, 5, 3, '2025-06-05'),
(6, 1, 4, '2025-06-06');

SELECT * FROM Enrollment

-- 1. View course faculties (title, level, category)
SELECT title, level, category FROM Course;

-- 2. Beginner courses in Data Science
SELECT title FROM Course 
WHERE level = 'Beginner' AND category = 'Data Science';

-- 3. The courses in which the trainee is registered (for example, ID = 1)
SELECT c.title 
FROM Enrollment e 
JOIN Course c ON e.course_id = c.course_id 
WHERE e.trainee_id = 1;

-- 4. Trainee Course Schedule (ID = 1)
SELECT s.start_date, s.time_slot 
FROM Enrollment e 
JOIN Schedule s ON e.course_id = s.course_id 
WHERE e.trainee_id = 1;

-- 5. How many courses is the trainee registered in? (ID = 1)
SELECT COUNT(*) 
FROM Enrollment 
WHERE trainee_id = 1;

-- 6. Title, trainer's name, and time period
SELECT c.title, t.name AS trainer_name, s.time_slot 
FROM Enrollment e 
JOIN Schedule s ON e.course_id = s.course_id 
JOIN Course c ON c.course_id = s.course_id 
JOIN Trainer t ON t.trainer_id = s.trainer_id 
WHERE e.trainee_id = 1;

-- 1. Display the courses taught by the trainer (ID = 1)
SELECT c.title 
FROM Schedule s 
JOIN Course c ON s.course_id = c.course_id 
WHERE s.trainer_id = 1;

-- 2. Upcoming sessions of the trainer
SELECT start_date, end_date, time_slot 
FROM Schedule 
WHERE trainer_id = 1;

-- 3. Number of trainees in each course taught by the trainer.
SELECT c.title, COUNT(e.trainee_id) AS trainee_count 
FROM Schedule s 
JOIN Course c ON s.course_id = c.course_id 
LEFT JOIN Enrollment e ON c.course_id = e.course_id 
WHERE s.trainer_id = 1 
GROUP BY c.title;

-- 4. Names and emails of trainees for each course.
SELECT t.name, t.email, c.title, tr.name AS trainee_name, tr.email AS trainee_email
FROM Schedule s 
JOIN Course c ON s.course_id = c.course_id 
JOIN Enrollment e ON e.course_id = c.course_id 
JOIN Trainee tr ON tr.trainee_id = e.trainee_id 
JOIN Trainer t ON t.trainer_id = s.trainer_id 
WHERE s.trainer_id = 1;

-- 5. Information about the trainer and the courses assigned to him.
SELECT name, phone, email FROM Trainer WHERE trainer_id = 1;

-- 6. How many courses does the trainer teach?
SELECT COUNT(DISTINCT course_id) 
FROM Schedule 
WHERE trainer_id = 1;

-- 1. Add a new course
INSERT INTO Course VALUES (5, 'AI Basics', 'AI', 20, 'Beginner');

-- 2. Add a new table
INSERT INTO Schedule VALUES (5, 5, 3, '2025-07-25', '2025-08-05', 'Evening');

-- 3. View all recordings with schedule and course information.
SELECT tr.name AS trainee_name, c.title, s.start_date, s.time_slot 
FROM Enrollment e 
JOIN Trainee tr ON e.trainee_id = tr.trainee_id 
JOIN Course c ON e.course_id = c.course_id 
JOIN Schedule s ON c.course_id = s.course_id;

-- 4. How many courses per trainer?
SELECT t.name, COUNT(DISTINCT s.course_id) AS course_count 
FROM Trainer t 
JOIN Schedule s ON t.trainer_id = s.trainer_id 
GROUP BY t.name;

-- 5. Trainees registered in "Data Basics"
SELECT tr.name, tr.email 
FROM Enrollment e 
JOIN Trainee tr ON e.trainee_id = tr.trainee_id 
JOIN Course c ON e.course_id = c.course_id 
WHERE c.title = 'Data Basics';

-- 6. The course with the most recordings
SELECT TOP 1 
    c.title, 
    COUNT(e.enrollment_id) AS total_enrolled
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
GROUP BY c.title
ORDER BY total_enrolled DESC;


-- 7. Sort tables by start date
SELECT * FROM Schedule 
ORDER BY start_date ASC;

