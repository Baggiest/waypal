-- Create Tables for WayPal QR Code Management System
-- This script creates all necessary tables with appropriate foreign key constraints

-- Users table
CREATE TABLE "user" (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Business Categories table
CREATE TABLE business_category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Businesses table
CREATE TABLE business (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(255),
    website VARCHAR(255),
    category_id INTEGER REFERENCES business_category(id) ON DELETE SET NULL,
    owner_id INTEGER REFERENCES "user"(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Business Links table (social media, etc.)
CREATE TABLE business_link (
    id SERIAL PRIMARY KEY,
    business_id INTEGER NOT NULL REFERENCES business(id) ON DELETE CASCADE,
    platform VARCHAR(50) NOT NULL,
    url VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- QR Codes table
CREATE TABLE qr_code (
    id SERIAL PRIMARY KEY,
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    business_id INTEGER NOT NULL REFERENCES business(id) ON DELETE CASCADE,
    owner_id INTEGER NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    metadata JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- QR Code Scans table
CREATE TABLE qr_code_scan (
    id SERIAL PRIMARY KEY,
    qr_code_id INTEGER NOT NULL REFERENCES qr_code(id),
    device_info VARCHAR(255),
    location VARCHAR(255),
    referrer VARCHAR(255),
    metadata JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX idx_business_category_id ON business(category_id);
CREATE INDEX idx_business_owner_id ON business(owner_id);
CREATE INDEX idx_business_link_business_id ON business_link(business_id);
CREATE INDEX idx_qr_code_business_id ON qr_code(business_id);
CREATE INDEX idx_qr_code_owner_id ON qr_code(owner_id);
CREATE INDEX idx_qr_code_scan_qr_code_id ON qr_code_scan(qr_code_id);
CREATE INDEX idx_business_location ON business USING GIST (ST_SetSRID(ST_MakePoint(longitude, latitude), 4326));

-- Add PostGIS extension if not already added
-- CREATE EXTENSION IF NOT EXISTS postgis;

-- Explanation of ON DELETE CASCADE decisions:

-- 1. Business to QR Codes: YES - If a business is deleted, all its QR codes are deleted
-- 2. Business to Business Links: YES - If a business is deleted, all its social media links are deleted
-- 3. QR Code to QR Code Scans: NO - If a QR code is deleted, scan history is preserved for analytics
-- 4. User to QR Codes: YES - If a user is deleted, all QR codes they own are deleted
-- 5. Business Category to Businesses: NO (SET NULL) - If a category is deleted, businesses keep their category_id as NULL
-- 6. User to Businesses: YES - If a user is deleted, all businesses they own are deleted

-- Note: This script assumes PostgreSQL with PostGIS extension for spatial queries.
-- For other databases, you may need to adjust the syntax accordingly. 