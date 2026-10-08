# Smart Water Usage Monitoring and Automated Billing Management Platform

## 1. Project Overview
The **Smart Water Usage Monitoring and Automated Billing Management Platform** is designed to provide transparent, automated, and granular water consumption monitoring and billing for residential communities and apartment complexes. The platform tracks individual household water meters, correlates usage against apartment infrastructure, and automates billing cycles and usage analytics.

---

## 2. Current Project Status
- **Phase:** Initial Backend Foundation (Day 1)
- **Status:** The foundational Spring Boot backend is initialized with database connectivity, Flyway migration versioning, and initial domain entity models.
- **Application Build:** Compiles cleanly with Maven (`BUILD SUCCESS`).
- **Application Startup:** Verified running on port 8080 with successful Flyway migration execution and Hibernate validation.

---

## 3. Currently Implemented Features
Only foundational architecture and data models have been implemented so far:
- **Project Scaffolding:** Standard Spring Boot 3.4.4 Maven project structure.
- **Database Connection & Validation:** PostgreSQL connection pool (HikariCP) configured with `spring.jpa.hibernate.ddl-auto=validate`.
- **Database Versioning:** Flyway migration system configured and active.
- **Initial Database Schema (Migration V1):**
  - `apartment` table created with primary key and metadata.
  - `household` table created with primary key, foreign key reference, and lookup indexes.
- **JPA Domain Entities:**
  - `Apartment`: mapped to `apartment` table, containing Bean Validation and timestamp hooks.
  - `Household`: mapped to `household` table, containing Bean Validation and timestamp hooks.
- **Entity Relationship:** Bidirectional One-to-Many (`Apartment 1 ---- * Household`) with lazy loading on the child side.

---

## 4. Planned Features (Not Yet Implemented)
The following modules and features are part of the platform roadmap and are **NOT** yet implemented:
- [ ] User authentication, authorization, and role management (JWT / Spring Security)
- [ ] Water usage meter logging & telemetry ingestion APIs
- [ ] Automated tariff planning & rate calculation engine
- [ ] Billing cycle management and automated invoice generation
- [ ] Real-time leak detection and abnormal usage alerts
- [ ] Repositories, Service layer, and REST Controllers
- [ ] Frontend user interface (React)
- [ ] Automated email/SMS notifications

---

## 5. Technology Stack Present in the Project
- **Language:** Java 21 (LTS)
- **Framework:** Spring Boot 3.4.4
- **Build Tool:** Apache Maven 3.9+
- **Database:** PostgreSQL
- **Persistence / ORM:** Spring Data JPA / Hibernate Core 6.6
- **Database Migrations:** Flyway (`flyway-core`, `flyway-database-postgresql`)
- **Validation:** Jakarta Validation (`spring-boot-starter-validation`)
- **Developer Tools:** Spring Boot DevTools

---

## 6. Current Project Structure
```text
.
├── .gitignore
├── README.md
└── backend
    ├── pom.xml
    └── src
        ├── main
        │   ├── java
        │   │   └── com
        │   │       └── smartwater
        │   │           └── smart_water_monitoring
        │   │               ├── SmartWaterMonitoringApplication.java
        │   │               └── entity
        │   │                   ├── Apartment.java
        │   │                   └── Household.java
        │   └── resources
        │       ├── application.properties
        │       └── db
        │           └── migration
        │               └── V1__create_apartment_and_household_tables.sql
        └── test
            └── java
                └── com
                    └── smartwater
                        └── smart_water_monitoring
                            └── SmartWaterMonitoringApplicationTests.java
```

---

## 7. Current Database Setup
- **Database Name:** `smart_water_monitoring`
- **Default Port:** `5432`
- **Driver:** PostgreSQL JDBC Driver (`org.postgresql.Driver`)
- **Schema Management:** Strict validation mode (`spring.jpa.hibernate.ddl-auto=validate`). Hibernate will not alter or auto-generate tables; all schema modifications must be scripted via Flyway migrations.

---

## 8. Current Entities and Relationships

### Tables and Columns

1. **`apartment`**
   - `apartment_id` (`BIGSERIAL`, PK)
   - `apartment_name` (`VARCHAR(150)`, NOT NULL)
   - `address` (`VARCHAR(255)`, NOT NULL)
   - `city` (`VARCHAR(100)`, NOT NULL)
   - `state` (`VARCHAR(100)`, NOT NULL)
   - `pincode` (`VARCHAR(10)`, NOT NULL)
   - `total_households` (`INT`, NOT NULL, DEFAULT 0)
   - `created_at` (`TIMESTAMP`, NOT NULL, DEFAULT NOW())
   - `updated_at` (`TIMESTAMP`, NOT NULL, DEFAULT NOW())

2. **`household`**
   - `household_id` (`BIGSERIAL`, PK)
   - `apartment_id` (`BIGINT`, NOT NULL, FK → `apartment.apartment_id`)
   - `house_number` (`VARCHAR(20)`, NOT NULL)
   - `floor_number` (`INT`, NOT NULL)
   - `members_count` (`INT`, NOT NULL, DEFAULT 0)
   - `meter_number` (`VARCHAR(50)`, NOT NULL, UNIQUE)
   - `status` (`VARCHAR(20)`, NOT NULL, DEFAULT 'ACTIVE')
   - `created_at` (`TIMESTAMP`, NOT NULL, DEFAULT NOW())
   - `updated_at` (`TIMESTAMP`, NOT NULL, DEFAULT NOW())

### Relationships
- **`Apartment` (1) ───< (Many) `Household`**
  - In `Apartment.java`: `@OneToMany(mappedBy = "apartment", cascade = CascadeType.ALL, orphanRemoval = true)`
  - In `Household.java`: `@ManyToOne(fetch = FetchType.LAZY, optional = false)` with `@JoinColumn(name = "apartment_id")`

---

## 9. Flyway Migration Information
- **Migration Directory:** `backend/src/main/resources/db/migration/`
- **Active Migrations:**
  - `V1__create_apartment_and_household_tables.sql`: Creates initial `apartment` and `household` tables, foreign key constraints (`fk_household_apartment`), and performance indexes (`idx_household_apartment_id`, `idx_household_status`, `idx_household_meter_number`).
- **History Table:** Flyway maintains applied migrations in the `flyway_schema_history` table inside the database.

---

## 10. Local Setup Requirements
Each team member needs to have installed:
- **Java Development Kit (JDK):** Version 21 or higher
- **Apache Maven:** Version 3.8 or higher
- **PostgreSQL:** Version 15+ running locally on port 5432
- **A local PostgreSQL database:** named `smart_water_monitoring`

---

## 11. How to Clone and Run the Project

### Step 1: Clone the repository
```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd smart-water-monitoring
```
*(or navigate to the project directory where the repository was cloned)*

### Step 2: Create the local PostgreSQL database
Log in to PostgreSQL CLI (`psql`) or pgAdmin and run:
```sql
CREATE DATABASE smart_water_monitoring;
```

### Step 3: Set your local environment variable
Set your PostgreSQL password in your terminal session (do not modify `application.properties`):

**PowerShell (Windows):**
```powershell
$env:DB_PASSWORD = "your_postgres_password"
```

**Bash / macOS / Linux:**
```bash
export DB_PASSWORD="your_postgres_password"
```

### Step 4: Build and run the backend
```bash
cd backend
mvn spring-boot:run
```

Flyway will automatically detect your fresh database, create the `flyway_schema_history` table, apply `V1__create_apartment_and_household_tables.sql`, and start the Tomcat web server on `http://localhost:8080`.

---

## 12. Git / GitHub Team Workflow
To ensure repository stability and clean version history:
1. **Never commit directly to `main`:** Always create a feature branch (`git checkout -b feature/feature-name`).
2. **Never commit build artifacts or secrets:** Ensure all generated files (`target/`, IDE settings) remain ignored.
3. **Database schema changes:** Always write incremental Flyway migration scripts (`V2__...sql`, `V3__...sql`) rather than editing existing migrations or modifying tables manually.
4. **Pull Requests:** Open a pull request against `main` and ensure Maven clean compile succeeds before merging.

---

## 13. Security Note
- **Environment Variables:** The database password is read dynamically via `${DB_PASSWORD}`.
- **Never hardcode secrets:** Never commit passwords, API keys, tokens, or private credentials into `application.properties` or any Git-tracked file.
- **Local Overrides:** Any local environment files (`.env`, `application-local.properties`) are explicitly excluded by `.gitignore`.
