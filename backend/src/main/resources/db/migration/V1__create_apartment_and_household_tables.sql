-- ============================================================
-- V1 : Create apartment and household tables
-- Smart Water Usage Monitoring Platform
-- ============================================================

-- ------------------------------------------------------------
-- TABLE: apartment
-- ------------------------------------------------------------
CREATE TABLE apartment (
    apartment_id   BIGSERIAL       PRIMARY KEY,
    apartment_name VARCHAR(150)    NOT NULL,
    address        VARCHAR(255)    NOT NULL,
    city           VARCHAR(100)    NOT NULL,
    state          VARCHAR(100)    NOT NULL,
    pincode        VARCHAR(10)     NOT NULL,
    total_households INT           NOT NULL DEFAULT 0,
    created_at     TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- ------------------------------------------------------------
-- TABLE: household
-- ------------------------------------------------------------
CREATE TABLE household (
    household_id   BIGSERIAL       PRIMARY KEY,
    apartment_id   BIGINT          NOT NULL,
    house_number   VARCHAR(20)     NOT NULL,
    floor_number   INT             NOT NULL,
    members_count  INT             NOT NULL DEFAULT 0,
    meter_number   VARCHAR(50)     NOT NULL UNIQUE,
    status         VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE',
    created_at     TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMP       NOT NULL DEFAULT NOW(),

    -- Foreign key: household → apartment (One Apartment → Many Households)
    CONSTRAINT fk_household_apartment
        FOREIGN KEY (apartment_id)
        REFERENCES apartment (apartment_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Indexes for common lookup patterns
CREATE INDEX idx_household_apartment_id ON household (apartment_id);
CREATE INDEX idx_household_status       ON household (status);
CREATE INDEX idx_household_meter_number ON household (meter_number);
