USE clubsphere_db;

-- BCrypt hash for password "password123":
-- $2a$10$e8w.Ua19mkyJ2dO1vj3iZ.zR485wU6dIuBlyF2wM/2l1nE3fE3FmG
-- We also generate a standard BCrypt salt for test users.
-- We will write a Java PasswordUtil that verifies passwords and handles BCrypt, with backward-compatible fallbacks if necessary.
-- Hash: $2a$10$wTqS4hA7B7n24MhCjM5lquuJb4Z70oFqPz0aTqVvYpX0lI9PZkMre (standard password123 hash)
-- Or generated dynamically by BCrypt.

-- Insert Users
-- Password for all seed users is 'password123'
-- Genuine BCrypt hash: $2a$10$xP4dhIKzva/jBOF1zgSege9dyLK3k9hUFf3KeTkBfYNRfs2aeU8bq
INSERT INTO users (id, username, email, password_hash, full_name, role, student_id, phone, department, year_of_study) VALUES
(1, 'admin', 'admin@aryacollege.in', '$2a$10$xP4dhIKzva/jBOF1zgSege9dyLK3k9hUFf3KeTkBfYNRfs2aeU8bq', 'Prof. R. K. Sharma', 'ADMIN', 'FAC-001', '+91 9829012345', 'Computer Science & Engineering', 'Faculty'),
(2, 'head_coding', 'head.coding@aryacollege.in', '$2a$10$xP4dhIKzva/jBOF1zgSege9dyLK3k9hUFf3KeTkBfYNRfs2aeU8bq', 'Aman Verma', 'CLUB_HEAD', '21ARYACS042', '+91 9829111222', 'Computer Science & Engineering', '4th Year'),
(3, 'head_robotics', 'head.robotics@aryacollege.in', '$2a$10$xP4dhIKzva/jBOF1zgSege9dyLK3k9hUFf3KeTkBfYNRfs2aeU8bq', 'Pooja Agarwal', 'CLUB_HEAD', '21ARYAEC018', '+91 9829222333', 'Electronics & Communication', '4th Year'),
(4, 'head_ai', 'head.ai@aryacollege.in', '$2a$10$xP4dhIKzva/jBOF1zgSege9dyLK3k9hUFf3KeTkBfYNRfs2aeU8bq', 'Rohan Saxena', 'CLUB_HEAD', '22ARYAAI005', '+91 9829333444', 'Artificial Intelligence & DS', '3rd Year'),
(5, 'head_cyber', 'head.cyber@aryacollege.in', '$2a$10$xP4dhIKzva/jBOF1zgSege9dyLK3k9hUFf3KeTkBfYNRfs2aeU8bq', 'Vikas Meena', 'CLUB_HEAD', '21ARYAIT029', '+91 9829444555', 'Information Technology', '4th Year'),
(6, 'head_cultural', 'head.cultural@aryacollege.in', '$2a$10$xP4dhIKzva/jBOF1zgSege9dyLK3k9hUFf3KeTkBfYNRfs2aeU8bq', 'Ananya Gupta', 'CLUB_HEAD', '22ARYAEE012', '+91 9829555666', 'Electrical Engineering', '3rd Year'),
(7, 'head_music', 'head.music@aryacollege.in', '$2a$10$xP4dhIKzva/jBOF1zgSege9dyLK3k9hUFf3KeTkBfYNRfs2aeU8bq', 'Kunal Joshi', 'CLUB_HEAD', '22ARYACS088', '+91 9829666777', 'Computer Science & Engineering', '3rd Year'),
(8, 'member_coding_1', 'priya.sharma@aryacollege.in', '$2a$10$xP4dhIKzva/jBOF1zgSege9dyLK3k9hUFf3KeTkBfYNRfs2aeU8bq', 'Priya Sharma', 'CLUB_MEMBER', '23ARYACS055', '+91 9829777888', 'Computer Science & Engineering', '2nd Year'),
(9, 'member_coding_2', 'rahul.singh@aryacollege.in', '$2a$10$xP4dhIKzva/jBOF1zgSege9dyLK3k9hUFf3KeTkBfYNRfs2aeU8bq', 'Rahul Singh', 'CLUB_MEMBER', '23ARYACS091', '+91 9829888999', 'Computer Science & Engineering', '2nd Year'),
(10, 'member_robotics_1', 'mohit.yadav@aryacollege.in', '$2a$10$xP4dhIKzva/jBOF1zgSege9dyLK3k9hUFf3KeTkBfYNRfs2aeU8bq', 'Mohit Yadav', 'CLUB_MEMBER', '23ARYAEC034', '+91 9829999000', 'Electronics & Communication', '2nd Year'),
(11, 'student_1', 'dev.kumar@aryacollege.in', '$2a$10$xP4dhIKzva/jBOF1zgSege9dyLK3k9hUFf3KeTkBfYNRfs2aeU8bq', 'Devendra Kumar', 'STUDENT', '23ARYACS101', '+91 9123456780', 'Computer Science & Engineering', '2nd Year'),
(12, 'student_2', 'sakshi.mishra@aryacollege.in', '$2a$10$xP4dhIKzva/jBOF1zgSege9dyLK3k9hUFf3KeTkBfYNRfs2aeU8bq', 'Sakshi Mishra', 'STUDENT', '24ARYACS014', '+91 9123456781', 'Computer Science & Engineering', '1st Year'),
(13, 'student_3', 'kartik.patel@aryacollege.in', '$2a$10$xP4dhIKzva/jBOF1zgSege9dyLK3k9hUFf3KeTkBfYNRfs2aeU8bq', 'Kartik Patel', 'STUDENT', '23ARYAME022', '+91 9123456782', 'Mechanical Engineering', '2nd Year')
ON DUPLICATE KEY UPDATE password_hash=VALUES(password_hash), full_name=VALUES(full_name);

-- Insert 26 College Clubs
INSERT INTO clubs (id, club_code, name, category, description, head_user_id, faculty_advisor, contact_email, contact_phone, meeting_venue, status) VALUES
(1, 'ARYA-CODING', 'Arya Coding Ninjas Club', 'Technical', 'Premier programming and algorithm society focusing on competitive coding, hackathons, and software engineering.', 2, 'Dr. Manish Bhardwaj', 'coding.club@aryacollege.in', '+91 9829111222', 'Advanced Computing Lab 3', 'ACTIVE'),
(2, 'ARYA-ROBOTICS', 'Arya Robotics & Mechatronics Society', 'Technical', 'Designing automated rovers, drones, line followers, and competing in national level robowars.', 3, 'Dr. Sandeep Chaurasia', 'robotics@aryacollege.in', '+91 9829222333', 'Robotics Innovation Center', 'ACTIVE'),
(3, 'ARYA-AI-DS', 'Artificial Intelligence & Data Science Club', 'Technical', 'Pioneering machine learning research, deep learning workshops, and computer vision hands-on bootcamps.', 4, 'Prof. Shalini Rathore', 'aids.club@aryacollege.in', '+91 9829333444', 'AI & Cloud Computing Lab', 'ACTIVE'),
(4, 'ARYA-CYBER', 'Arya Cyber Security & Ethical Hacking Guild', 'Technical', 'Exploring network penetration testing, CTF security challenges, cryptography, and cyber defense.', 5, 'Prof. Arvind Mathur', 'cybersec@aryacollege.in', '+91 9829444555', 'Cyber Security Center Block B', 'ACTIVE'),
(5, 'ARYA-CULTURAL', 'Spandan Cultural Society', 'Cultural', 'Fostering cultural diversity, theatre, street plays (Nukkad Natak), and annual fest celebrations.', 6, 'Dr. Preeti Trivedi', 'spandan@aryacollege.in', '+91 9829555666', 'Main Campus Central Auditorium', 'ACTIVE'),
(6, 'ARYA-MUSIC', 'Symphony Music & Band Club', 'Cultural', 'Orchestrating campus rock bands, classical vocalists, instrumental jam sessions, and musical evenings.', 7, 'Prof. Deepak Khandelwal', 'symphony@aryacollege.in', '+91 9829666777', 'Acoustic Arts Room 102', 'ACTIVE'),
(7, 'ARYA-DANCE', 'Footloose Dance Troupe', 'Cultural', 'Expressive contemporary, hip-hop, western, and folk dance crew representing Arya across inter-collegiate fests.', NULL, 'Dr. Sunita Pareek', 'dance@aryacollege.in', '+91 9829777111', 'Dance & Fitness Studio', 'ACTIVE'),
(8, 'ARYA-DRAMA', 'Rangmanch Dramatic Club', 'Cultural', 'Stage plays, improv comedy, scriptwriting, and dramatic expression fostering theatrical talent.', NULL, 'Prof. Rajesh Joshi', 'dramatics@aryacollege.in', '+91 9829777222', 'Mini Open Air Theatre', 'ACTIVE'),
(9, 'ARYA-LIT', 'Literary & Debating Society (LitSoc)', 'Literary', 'Parliamentary debates, Model United Nations (MUN), creative writing, elocution, and book club reads.', NULL, 'Dr. K. N. Sen', 'litsoc@aryacollege.in', '+91 9829777333', 'Central Library Seminar Hall', 'ACTIVE'),
(10, 'ARYA-PHOTO', 'Iris Photography & Cinematography Club', 'Creative', 'Capturing campus life, photo-walks, short film making, color grading, and visual storytelling.', NULL, 'Prof. Alok Choudhary', 'photo@aryacollege.in', '+91 9829777444', 'Media Production Studio', 'ACTIVE'),
(11, 'ARYA-DESIGN', 'Pixel & Vector UI/UX Design Club', 'Creative', 'Empowering digital artists, Figma UI/UX architects, 3D blender modelers, and brand designers.', NULL, 'Prof. Neha Singhal', 'design@aryacollege.in', '+91 9829777555', 'Graphics Design Workstation Lab', 'ACTIVE'),
(12, 'ARYA-INNOVATE', 'Institution Innovation Council (IIC) & E-Cell', 'Entrepreneurship', 'Incubating startup ideas, angel investment pitch decks, patent filing guidance, and founder fireside chats.', NULL, 'Dr. Vikramaditya Rawat', 'ecell@aryacollege.in', '+91 9829777666', 'Incubation & Startup Hub', 'ACTIVE'),
(13, 'ARYA-NSS', 'National Service Scheme (NSS Unit)', 'Social Service', 'Community outreach, blood donation drives, village education camps, and environmental conservation.', NULL, 'Dr. M. S. Rathore', 'nss@aryacollege.in', '+91 9829777777', 'NSS Campus Cell Office', 'ACTIVE'),
(14, 'ARYA-ECO', 'Prakriti Green Earth & Eco Club', 'Social Service', 'Tree plantation, waste recycling management, solar awareness, and sustainability campaigns on campus.', NULL, 'Prof. Sunita Meena', 'ecoclub@aryacollege.in', '+91 9829777888', 'Botanical Garden Pavilion', 'ACTIVE'),
(15, 'ARYA-SPORTS', 'Arya Athletic & Sports Club', 'Sports', 'Cricket, football, badminton, basketball tournaments, and fitness camps training university athletes.', NULL, 'Coach Virendra Singh', 'sports@aryacollege.in', '+91 9829777999', 'Sports Complex & Pavilion Ground', 'ACTIVE'),
(16, 'ARYA-ESPORTS', 'Valor Game Dev & Esports Guild', 'Technical', 'Game development in Unity/Unreal Engine, tournament hosting for BGMI, Valorant, and game physics testing.', NULL, 'Prof. Tarun Gupta', 'esports@aryacollege.in', '+91 9829888000', 'High-Performance Gaming Room', 'ACTIVE'),
(17, 'ARYA-IOT', 'Internet of Things & Embedded Systems Club', 'Technical', 'Arduino, Raspberry Pi, sensor telemetry, smart home automation, and smart campus IoT sensors.', NULL, 'Dr. Naveen Jangid', 'iot@aryacollege.in', '+91 9829888111', 'IoT Hardware Lab Block C', 'ACTIVE'),
(18, 'ARYA-CLOUD', 'AWS & Cloud Computing Community', 'Technical', 'DevOps, Docker, Kubernetes, AWS/GCP cloud architect training, and site reliability engineering.', NULL, 'Prof. Ankit Jain', 'cloud@aryacollege.in', '+91 9829888222', 'Cloud Server Center', 'ACTIVE'),
(19, 'ARYA-WEB3', 'Blockchain & Web3 Builders Society', 'Technical', 'Smart contracts, Ethereum solidity dev, decentralized finance (DeFi), and crypto consensus protocols.', NULL, 'Prof. Harish Poonia', 'web3@aryacollege.in', '+91 9829888333', 'FinTech Research Wing', 'ACTIVE'),
(20, 'ARYA-AERO', 'Aeromodelling & Aerospace Club', 'Technical', 'RC aircraft fabrication, quadcopter drones, wind-tunnel testing, and rocket propulsion simulations.', NULL, 'Dr. Sudhir Sharma', 'aeroclub@aryacollege.in', '+91 9829888444', 'Aeronautical Workshop Hangar', 'ACTIVE'),
(21, 'ARYA-AUTO', 'Society of Automotive Engineers (SAE Collegiate)', 'Technical', 'Formula Bharat race car designing, electric vehicle (EV) battery packs, and BAJA off-road vehicle fabrication.', NULL, 'Dr. Kuldeep Soni', 'sae@aryacollege.in', '+91 9829888555', 'Automobile Engineering Workshop', 'ACTIVE'),
(22, 'ARYA-FINEARTS', 'Chitrakala Fine Arts & Painting Guild', 'Creative', 'Canvas painting, oil sketches, ceramic pottery, modern graffiti, and college campus wall murals.', NULL, 'Prof. Renu Saxena', 'finearts@aryacollege.in', '+91 9829888666', 'Art & Craft Studio 204', 'ACTIVE'),
(23, 'ARYA-ASTRONOMY', 'Cosmos Astronomy & Stargazing Club', 'Science', 'Telescope night observations, astrophysics discussions, astrophotography, and planetary simulations.', NULL, 'Dr. B. K. Tiwari', 'astronomy@aryacollege.in', '+91 9829888777', 'Science Terrace Observatory', 'ACTIVE'),
(24, 'ARYA-QUIZ', 'Mindbender Quizzing Club', 'Literary', 'General knowledge trivia, science quizzes, business quizzes, and inter-college quiz bowls.', NULL, 'Prof. Sanjay Sharma', 'quiz@aryacollege.in', '+91 9829888888', 'Library Conference Room 2', 'ACTIVE'),
(25, 'ARYA-WOMEN-TECH', 'Women in Tech (WiT) Arya Chapter', 'Empowerment', 'Mentorship for women engineers, leadership development, coding hackathons, and tech diversity summits.', NULL, 'Dr. Kavita Choudhary', 'wit@aryacollege.in', '+91 9829888999', 'Girls Common Room Seminar Hall', 'ACTIVE'),
(26, 'ARYA-YOGA', 'Zenith Yoga & Mental Wellness Club', 'Wellness', 'Daily mindful meditation, stress relief workshops for exams, holistic health, and pranayama.', NULL, 'Prof. Om Prakash', 'yoga@aryacollege.in', '+91 9829999111', 'Yoga & Wellness Lawn Ground', 'ACTIVE')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- Insert Club Memberships
INSERT INTO club_members (club_id, user_id, member_role, joined_date, status, notes) VALUES
(1, 2, 'COORDINATOR', '2025-08-01', 'ACTIVE', 'Club Lead'),
(1, 8, 'MEMBER', '2025-09-01', 'ACTIVE', 'Competitive programmer - CP Core Team'),
(1, 9, 'MEMBER', '2025-09-15', 'ACTIVE', 'Web developer - Hackathon Lead'),
(2, 3, 'COORDINATOR', '2025-08-01', 'ACTIVE', 'Robotics Lead'),
(2, 10, 'MEMBER', '2025-09-10', 'ACTIVE', 'Hardware designer - Circuit design team')
ON DUPLICATE KEY UPDATE member_role=VALUES(member_role);

-- Insert Sample Events
INSERT INTO events (id, title, club_id, description, event_date, start_time, end_time, venue, registration_deadline, capacity, registered_count, event_type, participation_type, status, qr_token, created_by_user_id) VALUES
(1, 'HackArya 2026: 36-Hour National Hackathon', 1, 'The flagship national hackathon of Arya College! Compete in AI, Web3, FinTech, and IoT tracks. Prizes worth INR 1,50,000 + Internship offers.', '2026-11-15', '09:00:00', '21:00:00', 'Arya Central Auditorium & Labs', '2026-11-10 23:59:59', 200, 2, 'HACKATHON', 'BOTH', 'REGISTRATION_OPEN', 'QR_HACKARYA_2026_TOKEN_01', 2),
(2, 'RoboWars & Line Follower Championship', 2, 'Build your combat bot and autonomous maze solver! Witness heavy-weight steel crush battles and high speed line followers.', '2026-11-20', '10:00:00', '17:00:00', 'Sports Arena Ground', '2026-11-16 18:00:00', 120, 1, 'COMPETITION', 'GROUP', 'REGISTRATION_OPEN', 'QR_ROBOWARS_2026_TOKEN_02', 3),
(3, 'Mastering Generative AI & LLMs Hands-on BootCamp', 3, 'Deep-dive into Prompt Engineering, LangChain, Fine-tuning Open LLMs, and building Production Autonomous Agents.', '2026-10-28', '14:00:00', '17:30:00', 'Advanced Computing Lab 2', '2026-10-26 12:00:00', 80, 1, 'WORKSHOP', 'INDIVIDUAL', 'REGISTRATION_OPEN', 'QR_GENAI_BOOTCAMP_TOKEN_03', 4),
(4, 'Capture The Flag (CTF) Cyber Defense 2026', 4, 'Annual penetration testing contest covering Reverse Engineering, Cryptography, Web Exploitation, and Forensics.', '2026-11-05', '11:00:00', '16:00:00', 'Cyber Lab Block B', '2026-11-03 23:59:59', 60, 0, 'COMPETITION', 'INDIVIDUAL', 'REGISTRATION_OPEN', 'QR_CTF_CYBER_2026_TOKEN_04', 5),
(5, 'Spandan 2026: Inter-College Cultural Fest Auditions', 5, 'Auditions for drama, music bands, classical singing, and street theatre for the upcoming annual college gala fest.', '2026-11-25', '10:00:00', '18:00:00', 'Main Campus Open Air Theatre', '2026-11-22 20:00:00', 300, 0, 'CULTURAL', 'BOTH', 'UPCOMING', 'QR_SPANDAN_AUDITIONS_TOKEN_05', 6)
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- Insert Sample Registrations
INSERT INTO registrations (id, registration_number, event_id, user_id, registration_type, group_name, group_size, status, registered_at, special_requirements) VALUES
(1, 'REG-2026-HACK-001', 1, 11, 'GROUP', 'CodeKnights', 3, 'CONFIRMED', '2026-10-01 10:15:00', 'Require dual power outlets and LAN ports.'),
(2, 'REG-2026-HACK-002', 1, 12, 'INDIVIDUAL', NULL, 1, 'CONFIRMED', '2026-10-02 14:30:00', 'None'),
(3, 'REG-2026-ROBO-001', 2, 13, 'GROUP', 'RoboTitans', 2, 'CONFIRMED', '2026-10-03 16:45:00', 'Need battery recharge dock.'),
(4, 'REG-2026-GENAI-001', 3, 11, 'INDIVIDUAL', NULL, 1, 'CONFIRMED', '2026-10-04 09:20:00', 'Vegetarian lunch request')
ON DUPLICATE KEY UPDATE status=VALUES(status);

-- Insert Group Participants Details
INSERT INTO event_participants (registration_id, participant_name, student_id, email, phone, is_leader) VALUES
(1, 'Devendra Kumar', '23ARYACS101', 'dev.kumar@aryacollege.in', '+91 9123456780', TRUE),
(1, 'Aayush Sharma', '23ARYACS105', 'aayush.sharma@aryacollege.in', '+91 9123456788', FALSE),
(1, 'Nisha Jain', '23ARYACS112', 'nisha.jain@aryacollege.in', '+91 9123456799', FALSE),
(2, 'Sakshi Mishra', '24ARYACS014', 'sakshi.mishra@aryacollege.in', '+91 9123456781', TRUE),
(3, 'Kartik Patel', '23ARYAME022', 'kartik.patel@aryacollege.in', '+91 9123456782', TRUE),
(3, 'Deepak Saini', '23ARYAME040', 'deepak.saini@aryacollege.in', '+91 9123456783', FALSE),
(4, 'Devendra Kumar', '23ARYACS101', 'dev.kumar@aryacollege.in', '+91 9123456780', TRUE);

-- Insert Sample Tasks for Club Members
INSERT INTO tasks (id, club_id, event_id, title, description, assigned_to_user_id, assigned_by_user_id, due_date, priority, status) VALUES
(1, 1, 1, 'Setup Problem Statements & Test Cases', 'Coordinate with judges to prepare 5 hard algorithmic problems on Hackerearth platform for Round 1.', 8, 2, '2026-11-05', 'HIGH', 'IN_PROGRESS'),
(2, 1, 1, 'Sponsorship Brochure Distribution', 'Contact technical sponsors (RedHat, GitHub, Cloudflare) for merchandise and cloud credits.', 9, 2, '2026-10-25', 'MEDIUM', 'PENDING'),
(3, 2, 2, 'RoboWars Ring Safety Barricades Check', 'Inspect the acrylic sheets and steel guard rails in the sports ground for 15kg combat bot arena.', 10, 3, '2026-11-12', 'URGENT', 'PENDING')
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- Insert Sample Announcements
INSERT INTO announcements (id, club_id, created_by_user_id, title, content, priority, target_role) VALUES
(1, 1, 2, 'Welcome to HackArya 2026 Registrations!', 'Registrations are now officially live for HackArya 2026! All Arya students are encouraged to participate. Early registrations receive free swag kits.', 'URGENT', 'ALL'),
(2, 1, 2, 'Coding Club Core Team Meeting this Friday', 'Mandatory sync at 4:30 PM in Lab 3 to discuss event logistics, mentor assignments, and food arrangements.', 'IMPORTANT', 'MEMBERS_ONLY'),
(3, 2, 3, 'RoboWars Arena Construction Begins', 'Hardware teams are requested to assemble in the innovation center on Saturday morning.', 'NORMAL', 'ALL')
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- Insert Sample Notifications
INSERT INTO notifications (user_id, title, message, type, related_event_id, related_task_id, related_club_id, is_read) VALUES
(11, 'Registration Confirmed for HackArya 2026', 'Congratulations Devendra! Your team "CodeKnights" has been successfully registered for HackArya 2026. Registration ID: REG-2026-HACK-001.', 'REGISTRATION_CONFIRMED', 1, NULL, 1, FALSE),
(11, 'New Workshop: Generative AI & LLMs', 'Artificial Intelligence Club announced a new hands-on bootcamp. Seats are limited to 80.', 'EVENT_CREATED', 3, NULL, 3, FALSE),
(8, 'New Task Assigned: Setup Problem Statements', 'You have been assigned to prepare problem statements for HackArya 2026 by Aman Verma.', 'TASK_ASSIGNED', 1, 1, 1, FALSE),
(2, 'New Team Registration for HackArya', 'Team "CodeKnights" registered with 3 participants.', 'GENERAL', 1, NULL, 1, TRUE);
