-- CASCADE DELETE Statements for WayPal QR Code Management System
-- These statements modify the foreign key constraints to include ON DELETE CASCADE
-- where appropriate for the business logic of the application

-- 1. Business to QR Codes: If a business is deleted, all its QR codes should be deleted
ALTER TABLE qr_code
DROP CONSTRAINT IF EXISTS qr_code_business_id_fkey,
ADD CONSTRAINT qr_code_business_id_fkey
FOREIGN KEY (business_id)
REFERENCES business(id)
ON DELETE CASCADE;

-- 2. Business to Business Links: If a business is deleted, all its social media links should be deleted
ALTER TABLE business_link
DROP CONSTRAINT IF EXISTS business_link_business_id_fkey,
ADD CONSTRAINT business_link_business_id_fkey
FOREIGN KEY (business_id)
REFERENCES business(id)
ON DELETE CASCADE;

-- 3. QR Code to QR Code Scans: If a QR code is deleted, all its scan records should be deleted
-- Note: This is optional and depends on whether you want to preserve historical analytics data
-- Uncomment if you want to implement this behavior
/*
ALTER TABLE qr_code_scan
DROP CONSTRAINT IF EXISTS qr_code_scan_qr_code_id_fkey,
ADD CONSTRAINT qr_code_scan_qr_code_id_fkey
FOREIGN KEY (qr_code_id)
REFERENCES qr_code(id)
ON DELETE CASCADE;
*/

-- 4. User to QR Codes: If a user is deleted, all QR codes they own should be deleted
ALTER TABLE qr_code
DROP CONSTRAINT IF EXISTS qr_code_owner_id_fkey,
ADD CONSTRAINT qr_code_owner_id_fkey
FOREIGN KEY (owner_id)
REFERENCES "user"(id)
ON DELETE CASCADE;

