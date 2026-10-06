-- Arya College ClubSphere Database Schema & Complete Seed Data
-- Target Database: MySQL 8.0+ / 9.0+

CREATE DATABASE IF NOT EXISTS clubsphere_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE clubsphere_db;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(60) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('ADMIN', 'CLUB_HEAD', 'CLUB_MEMBER', 'STUDENT') NOT NULL,
    student_id VARCHAR(50) DEFAULT NULL,
    phone VARCHAR(20) DEFAULT NULL,
    department VARCHAR(100) DEFAULT NULL,
    year_of_study VARCHAR(20) DEFAULT NULL,
    avatar_url VARCHAR(255) DEFAULT 'default_avatar.png',
    status ENUM('ACTIVE', 'INACTIVE', 'SUSPENDED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_role (role),
    INDEX idx_user_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Clubs Table (26 College Clubs)
CREATE TABLE IF NOT EXISTS clubs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    club_code VARCHAR(30) NOT NULL UNIQUE,
    name VARCHAR(120) NOT NULL,
    category VARCHAR(60) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255) DEFAULT 'default_club.png',
    head_user_id INT NULL,
    faculty_advisor VARCHAR(100) DEFAULT 'Dr. Senior Professor, Arya College',
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    meeting_venue VARCHAR(100) DEFAULT 'Arya Main Campus Auditorium / Lab Block',
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (head_user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_club_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Club Members Table (Relationship between Users and Clubs)
CREATE TABLE IF NOT EXISTS club_members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    club_id INT NOT NULL,
    user_id INT NOT NULL,
    member_role ENUM('MEMBER', 'COORDINATOR', 'VICE_HEAD') DEFAULT 'MEMBER',
    joined_date DATE NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE', 'REMOVED') DEFAULT 'ACTIVE',
    notes VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_club_user (club_id, user_id),
    FOREIGN KEY (club_id) REFERENCES clubs(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_cm_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Events Table
CREATE TABLE IF NOT EXISTS events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    club_id INT NOT NULL,
    description TEXT,
    event_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    venue VARCHAR(150) NOT NULL,
    registration_deadline DATETIME NOT NULL,
    capacity INT NOT NULL DEFAULT 100,
    registered_count INT NOT NULL DEFAULT 0,
    event_type ENUM('WORKSHOP', 'SEMINAR', 'COMPETITION', 'CULTURAL', 'TECHNICAL', 'SPORTS', 'HACKATHON', 'EXHIBITION', 'OTHER') DEFAULT 'TECHNICAL',
    participation_type ENUM('INDIVIDUAL', 'GROUP', 'BOTH') NOT NULL DEFAULT 'INDIVIDUAL',
    status ENUM('UPCOMING', 'REGISTRATION_OPEN', 'REGISTRATION_CLOSED', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'REGISTRATION_OPEN',
    qr_token VARCHAR(64) NOT NULL UNIQUE,
    banner_url VARCHAR(255) DEFAULT 'event_default.png',
    created_by_user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (club_id) REFERENCES clubs(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by_user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_event_date (event_date),
    INDEX idx_event_status (status),
    INDEX idx_event_qr (qr_token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Registrations Table
CREATE TABLE IF NOT EXISTS registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    registration_number VARCHAR(64) NOT NULL UNIQUE,
    event_id INT NOT NULL,
    user_id INT NOT NULL,
    registration_type ENUM('INDIVIDUAL', 'GROUP') NOT NULL DEFAULT 'INDIVIDUAL',
    group_name VARCHAR(100) DEFAULT NULL,
    group_size INT DEFAULT 1,
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED') DEFAULT 'CONFIRMED',
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    special_requirements TEXT,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_event (event_id, user_id),
    INDEX idx_reg_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Event Participants Table (For Group Registrations details)
CREATE TABLE IF NOT EXISTS event_participants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    registration_id INT NOT NULL,
    participant_name VARCHAR(100) NOT NULL,
    student_id VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    is_leader BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (registration_id) REFERENCES registrations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. Tasks Table (Club Tasks for Members)
CREATE TABLE IF NOT EXISTS tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    club_id INT NOT NULL,
    event_id INT DEFAULT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    assigned_to_user_id INT NOT NULL,
    assigned_by_user_id INT NOT NULL,
    due_date DATE NOT NULL,
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') DEFAULT 'MEDIUM',
    status ENUM('PENDING', 'IN_PROGRESS', 'COMPLETED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (club_id) REFERENCES clubs(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_to_user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_by_user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_task_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. Announcements Table
CREATE TABLE IF NOT EXISTS announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    club_id INT NOT NULL,
    created_by_user_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    content TEXT NOT NULL,
    priority ENUM('NORMAL', 'IMPORTANT', 'URGENT') DEFAULT 'NORMAL',
    target_role ENUM('ALL', 'MEMBERS_ONLY') DEFAULT 'ALL',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (club_id) REFERENCES clubs(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by_user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9. Notifications Table
CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('EVENT_CREATED', 'REGISTRATION_CONFIRMED', 'EVENT_REMINDER', 'EVENT_CANCELLED', 'DEADLINE_ALERT', 'TASK_ASSIGNED', 'CLUB_ANNOUNCEMENT', 'GENERAL') NOT NULL,
    related_event_id INT DEFAULT NULL,
    related_task_id INT DEFAULT NULL,
    related_club_id INT DEFAULT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_notif_user_read (user_id, is_read)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 10. Audit / Activity Logs
CREATE TABLE IF NOT EXISTS activity_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT DEFAULT NULL,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    ip_address VARCHAR(50) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
