import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateInitialSchema1710000000000 implements MigrationInterface {
  name = 'CreateInitialSchema1710000000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Enable PostGIS extension
    await queryRunner.query(`CREATE EXTENSION IF NOT EXISTS postgis`);

    // Create users table
    await queryRunner.query(`
      CREATE TABLE "users" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "email" character varying NOT NULL,
        "passwordHash" character varying NOT NULL,
        "firstName" character varying NOT NULL,
        "lastName" character varying NOT NULL,
        "phone" character varying,
        "isAdmin" boolean NOT NULL DEFAULT false,
        "profileImage" character varying,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "UQ_users_email" UNIQUE ("email"),
        CONSTRAINT "PK_users" PRIMARY KEY ("id")
      )
    `);

    // Create business_categories table
    await queryRunner.query(`
      CREATE TABLE "business_categories" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "name" character varying NOT NULL,
        "description" character varying,
        "icon" character varying,
        "isActive" boolean NOT NULL DEFAULT true,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_business_categories" PRIMARY KEY ("id")
      )
    `);

    // Create businesses table
    await queryRunner.query(`
      CREATE TABLE "businesses" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "name" character varying NOT NULL,
        "description" character varying NOT NULL,
        "address" character varying NOT NULL,
        "location" geometry(Point,4326) NOT NULL,
        "website" character varying,
        "phone" character varying,
        "rating" decimal(3,2),
        "logo" character varying,
        "coverImage" character varying,
        "businessHours" character varying,
        "isActive" boolean NOT NULL DEFAULT true,
        "socialMedia" character varying,
        "menuUrl" character varying,
        "reservationUrl" character varying,
        "ownerId" uuid NOT NULL,
        "categoryId" uuid NOT NULL,
        "metadata" jsonb,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_businesses" PRIMARY KEY ("id"),
        CONSTRAINT "FK_businesses_owner" FOREIGN KEY ("ownerId") REFERENCES "users"("id") ON DELETE CASCADE,
        CONSTRAINT "FK_businesses_category" FOREIGN KEY ("categoryId") REFERENCES "business_categories"("id")
      )
    `);

    // Create business_links table
    await queryRunner.query(`
      CREATE TABLE "business_links" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "title" character varying NOT NULL,
        "url" character varying NOT NULL,
        "description" character varying,
        "icon" character varying,
        "order" integer NOT NULL DEFAULT 0,
        "isActive" boolean NOT NULL DEFAULT true,
        "businessId" uuid NOT NULL,
        "metadata" jsonb,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_business_links" PRIMARY KEY ("id"),
        CONSTRAINT "FK_business_links_business" FOREIGN KEY ("businessId") REFERENCES "businesses"("id") ON DELETE CASCADE
      )
    `);

    // Create qr_codes table
    await queryRunner.query(`
      CREATE TABLE "qr_codes" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "name" character varying NOT NULL,
        "code" character varying NOT NULL,
        "description" character varying,
        "imageUrl" character varying,
        "isActive" boolean NOT NULL DEFAULT true,
        "ownerId" uuid NOT NULL,
        "businessId" uuid NOT NULL,
        "metadata" jsonb,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_qr_codes" PRIMARY KEY ("id"),
        CONSTRAINT "FK_qr_codes_owner" FOREIGN KEY ("ownerId") REFERENCES "users"("id") ON DELETE CASCADE,
        CONSTRAINT "FK_qr_codes_business" FOREIGN KEY ("businessId") REFERENCES "businesses"("id") ON DELETE CASCADE
      )
    `);

    // Create qr_code_scans table
    await queryRunner.query(`
      CREATE TABLE "qr_code_scans" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "qrCodeId" uuid NOT NULL,
        "deviceInfo" character varying,
        "location" character varying,
        "referrer" character varying,
        "metadata" jsonb,
        "scannedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_qr_code_scans" PRIMARY KEY ("id"),
        CONSTRAINT "FK_qr_code_scans_qr_code" FOREIGN KEY ("qrCodeId") REFERENCES "qr_codes"("id") ON DELETE CASCADE
      )
    `);

    // Create indexes
    await queryRunner.query(`CREATE INDEX "IDX_businesses_location" ON "businesses" USING GIST ("location")`);
    await queryRunner.query(`CREATE INDEX "IDX_businesses_owner" ON "businesses" ("ownerId")`);
    await queryRunner.query(`CREATE INDEX "IDX_businesses_category" ON "businesses" ("categoryId")`);
    await queryRunner.query(`CREATE INDEX "IDX_business_links_business" ON "business_links" ("businessId")`);
    await queryRunner.query(`CREATE INDEX "IDX_qr_codes_owner" ON "qr_codes" ("ownerId")`);
    await queryRunner.query(`CREATE INDEX "IDX_qr_codes_business" ON "qr_codes" ("businessId")`);
    await queryRunner.query(`CREATE INDEX "IDX_qr_code_scans_qr_code" ON "qr_code_scans" ("qrCodeId")`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP INDEX "IDX_qr_code_scans_qr_code"`);
    await queryRunner.query(`DROP INDEX "IDX_qr_codes_business"`);
    await queryRunner.query(`DROP INDEX "IDX_qr_codes_owner"`);
    await queryRunner.query(`DROP INDEX "IDX_business_links_business"`);
    await queryRunner.query(`DROP INDEX "IDX_businesses_category"`);
    await queryRunner.query(`DROP INDEX "IDX_businesses_owner"`);
    await queryRunner.query(`DROP INDEX "IDX_businesses_location"`);
    await queryRunner.query(`DROP TABLE "qr_code_scans"`);
    await queryRunner.query(`DROP TABLE "qr_codes"`);
    await queryRunner.query(`DROP TABLE "business_links"`);
    await queryRunner.query(`DROP TABLE "businesses"`);
    await queryRunner.query(`DROP TABLE "business_categories"`);
    await queryRunner.query(`DROP TABLE "users"`);
  }
} 