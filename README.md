# Arya College ClubSphere

> **Arya College ClubSphere** is an enterprise-grade, centralized college club and event management platform built for **Arya College of Engineering & IT, Jaipur**. It centralizes the lifecycle of **26 college clubs**, students, core members, event registrations, QR codes, tasks, announcements, and reports.

---

## 🏛️ System Architecture

- **Architecture:** Layered MVC Architecture  
  `JSP → Jakarta Servlet → Service → DAO → JDBC → MySQL`
- **Frontend:** JSP, HTML5, Modern CSS3, JavaScript, Bootstrap 5.3, Bootstrap Icons
- **Backend:** Java 17 / 21, Jakarta EE 10 (Servlets 6.0, JSTL 3.0), Maven
- **Database:** MySQL 8.0+ / 9.0+ with HikariCP Connection Pooling
- **Security:** BCrypt Hashing, Role-Based Access Control (RBAC), URL-tamper protection, PreparedStatement SQL injection defense
- **Server:** Apache Tomcat 10.1+

---

## 👥 Supported Roles & Access Rights

1. **Admin / Professor:**
   - Full access to oversee all **26 clubs**.
   - Create, edit, and activate/deactivate clubs.
   - Assign Club Heads (lead coordinators) & faculty advisors.
   - Manage user directories & switch system roles.
   - Monitor all events, registrations, system audit logs, and analytics.

2. **Club Head:**
   - Isolated management of **their assigned club only** (cannot access other clubs).
   - Add and remove core club members.
   - Create, edit, and cancel events.
   - Generate, preview, and download **Event QR Codes** for registrations.
   - Assign and track member tasks.
   - Publish broadcast announcements (Public or Club-Members-Only).
   - View club reports & attendance rates.

3. **Club Member:**
   - Dedicated workspace for their affiliated clubs.
   - View and update status of assigned tasks (`PENDING`, `IN_PROGRESS`, `COMPLETED`).
   - Access internal club announcements and schedule.

4. **Student:**
   - Explore all **26 clubs** with responsive category filtering.
   - Register for events via **Individual** or **Group/Team** registration.
   - Direct QR code scanning: `/event/register?token=...`
   - Real-time registration history and pass reference tracking.
   - Profile management and notification center.

---

## 🏫 The 26 Official Arya College Clubs

| # | Club Code | Club Name | Category |
|---|---|---|---|
| 1 | `ARYA-CODING` | Arya Coding Ninjas Club | Technical |
| 2 | `ARYA-ROBOTICS` | Arya Robotics & Mechatronics Society | Technical |
| 3 | `ARYA-AI-DS` | Artificial Intelligence & Data Science Club | Technical |
| 4 | `ARYA-CYBER` | Arya Cyber Security & Ethical Hacking Guild | Technical |
| 5 | `ARYA-CULTURAL` | Spandan Cultural Society | Cultural |
| 6 | `ARYA-MUSIC` | Symphony Music & Band Club | Cultural |
| 7 | `ARYA-DANCE` | Footloose Dance Troupe | Cultural |
| 8 | `ARYA-DRAMA` | Rangmanch Dramatic Club | Cultural |
| 9 | `ARYA-LIT` | Literary & Debating Society (LitSoc) | Literary |
| 10 | `ARYA-PHOTO` | Iris Photography & Cinematography Club | Creative |
| 11 | `ARYA-DESIGN` | Pixel & Vector UI/UX Design Club | Creative |
| 12 | `ARYA-INNOVATE` | Institution Innovation Council (IIC) & E-Cell | Entrepreneurship |
| 13 | `ARYA-NSS` | National Service Scheme (NSS Unit) | Social Service |
| 14 | `ARYA-ECO` | Prakriti Green Earth & Eco Club | Social Service |
| 15 | `ARYA-SPORTS` | Arya Athletic & Sports Club | Sports |
| 16 | `ARYA-ESPORTS` | Valor Game Dev & Esports Guild | Technical |
| 17 | `ARYA-IOT` | Internet of Things & Embedded Systems Club | Technical |
| 18 | `ARYA-CLOUD` | AWS & Cloud Computing Community | Technical |
| 19 | `ARYA-WEB3` | Blockchain & Web3 Builders Society | Technical |
| 20 | `ARYA-AERO` | Aeromodelling & Aerospace Club | Technical |
| 21 | `ARYA-AUTO` | Society of Automotive Engineers (SAE Collegiate) | Technical |
| 22 | `ARYA-FINEARTS` | Chitrakala Fine Arts & Painting Guild | Creative |
| 23 | `ARYA-ASTRONOMY` | Cosmos Astronomy & Stargazing Club | Science |
| 24 | `ARYA-QUIZ` | Mindbender Quizzing Club | Literary |
| 25 | `ARYA-WOMEN-TECH` | Women in Tech (WiT) Arya Chapter | Empowerment |
| 26 | `ARYA-YOGA` | Zenith Yoga & Mental Wellness Club | Wellness |

---

## ⚙️ Quick Start & Setup Instructions

### 1. Database Setup
1. Ensure MySQL is running on your machine on port `3306`.
2. Execute the database schema and seed data scripts in MySQL:
   ```bash
   mysql -u root -p < database/schema.sql
   mysql -u root -p < database/seed.sql
   ```
3. Update database credentials if needed in `src/main/resources/application.properties`:
   ```properties
   db.url=jdbc:mysql://localhost:3306/clubsphere_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8
   db.username=root
   db.password=root
   ```

### 2. Build the Application
Run Maven to build the WAR file:
```bash
mvn clean package
```
This produces `target/aryaClgClubSphere.war`.

### 3. Deploy to Apache Tomcat 10.1
1. Copy `target/aryaClgClubSphere.war` to your Tomcat `webapps/` folder:
   ```bash
   cp target/aryaClgClubSphere.war <TOMCAT_DIR>/webapps/
   ```
2. Start Tomcat (`bin/startup.bat` or `bin/catalina.bat run`).
3. Access the platform at:
   ```
   http://localhost:8080/aryaClgClubSphere/
   ```

---

## 🔑 Demo Login Accounts

All seed users are provisioned with password: `password123`

| Role | Username | Email | Purpose |
|---|---|---|---|
| **Admin** | `admin` | `admin@aryacollege.in` | Full management of clubs, users, events, and reports |
| **Club Head** | `head_coding` | `head.coding@aryacollege.in` | Lead of Arya Coding Ninjas Club |
| **Club Head** | `head_robotics` | `head.robotics@aryacollege.in` | Lead of Arya Robotics Society |
| **Club Member** | `member_coding_1` | `priya.sharma@aryacollege.in` | Coding Ninjas member with assigned tasks |
| **Student** | `student_1` | `dev.kumar@aryacollege.in` | Student with active registrations and passes |
| **Student** | `student_2` | `sakshi.mishra@aryacollege.in` | Student account for event booking |

---

## 📱 QR Code Registration Flow

1. **Club Head:** Creates an event & clicks **QR Code** in their dashboard.
2. **QR Generation:** The system uses ZXing to create a unique high-resolution QR code encoding the URL:
   `/event/register?token=<UNIQUE_TOKEN>`
3. **Student Scan:** Scanning the QR directs the student straight to the event registration page.
4. **Registration:** Student selects Individual or Team format, provides participants, and receives an instant confirmed pass.
