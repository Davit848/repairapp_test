# Product Requirements Document (PRD) & Project Brief

**Project Name:** Repair — Vehicle Maintenance & Spare Parts Ecosystem  
**Document Version:** 1.2  
**Status:** Approved for Implementation  
**Target Platforms:** Mobile App (Flutter / Dart) & Backend Web Services (Laravel REST API + MySQL)  
**Target Region:** Southeast Asia (Initial Pilot: Phnom Penh, Cambodia)

---

## 1. Executive Summary & Vision

### 1.1 Problem Statement
Vehicle owners (motorcycle riders, car drivers, and commercial couriers) frequently encounter roadside breakdowns, scheduled maintenance hurdles, and difficulty locating genuine spare parts. Today, finding a qualified mechanic or nearby garage relies heavily on word-of-mouth or inaccurate web map pins with no live inventory data, unclear labor rates, or unverified shop coordinates. 

Conversely, local independent mechanics and garages lack modern digital tools to broadcast their real-time coordinates, advertise specialist repair services, manage stock levels, and accept on-demand rescue callouts.

### 1.2 Product Vision
**Repair** connects motorists in need of immediate roadside rescue, maintenance services, and vehicle spare parts with verified local garages and mobile mechanics. Built as an end-to-end ecosystem, Repair empowers service providers to manage both physical parts inventory and labor service catalogs while providing motorists with transparent GPS-driven discovery, fixed pricing, and one-tap emergency dispatch.

---

## 2. Target Personas & User Classes

| Persona | Role | Key Needs & Pain Points |
| :--- | :--- | :--- |
| **Motorist / Rider (Customer)** | Daily commuter or delivery driver | Immediate roadside assistance during breakdowns; discover nearby trusted garages; search and verify spare parts compatibility; transparent pricing without hidden markups. |
| **Shop Owner / Garage Manager** | Brick-and-mortar repair shop operator | Accurate GPS map pin for storefront; digital storefront for spare parts stock; inbound customer inquiries; tracking inventory and revenue. |
| **Mobile Mechanic (Technician)** | Independent technician or mobile mechanic | Flexible job dispatch; offering on-site/roadside rescue services; toggling availability radius; managing labor rates and service offerings. |
| **Guest User** | Unregistered visitor | Frictionless exploration of the map, nearby garages, and parts catalog without mandatory upfront sign-in. |

---

## 3. Information Architecture & Navigation

The mobile application utilizes a **Persistent 5-Tab Navigation Shell**:

```
┌──────────────────────────────────────────────────────────────┐
│                    Repair Mobile Application                 │
├─────────────┬─────────────┬─────────────┬────────────┬───────┤
│    🗺️ Map   │ 🧰 Services │   🛍️ Store  │  🔧 Manage │ 👤 Me │
└─────────────┴─────────────┴─────────────┴────────────┴───────┘
```

1. **🗺️ Map (Discovery Hub):** Real-time GPS location, radius scanning, categorized map markers (Motorcycle Repair, Car Garages, Spare Parts), and interactive bottom sheets for quick shop profiles, directions, and phone dispatch.
2. **🧰 Services (Labor Marketplace):** On-demand roadside rescue, scheduled workshop services, fixed upfront labor rates, estimated turnaround times, and delivery mode filters (In-Shop vs. Mobile Rescue).
3. **🛍️ Store (Parts Catalog):** Spare parts marketplace, barcode/keyword search, vehicle type filters (Motorcycle / Car / Universal), stock availability, and distance-to-seller indicators.
4. **🔧 Manage (Seller & Provider Portal):** Dual-mode dashboard for shop owners to manage physical stock (CRUD) and mechanics to manage bookable labor services, callout radii, and pricing models.
5. **👤 Profile (Account & Workshop Identity):** Mechanic/owner credentials, workshop working hours, GPS pin calibration, bilingual toggle (English / ភាសាខ្មែរ), security tokens, and account settings.

---

## 4. Key Functional Requirements & User Stories

### 4.1 Guest Mode & Authentication Flow
- **FR-AUTH-01:** Guests can browse the Map, Services marketplace, and Spare Parts store without an account.
- **FR-AUTH-02:** When attempting privileged actions (creating a shop, listing parts, publishing services, managing stock), guests are prompted with a lightweight Register/Login modal.
- **FR-AUTH-03:** User registration requires Full Name, Email/Gmail, Phone Number, and Password confirmation.
- **FR-AUTH-04:** JWT / Laravel Sanctum bearer token authentication ensures secure API session management.

### 4.2 Module 1: GPS Map & Garage Locator (`Page 1 — Map`)
- **FR-MAP-01 (Real-Time Positioning):** Pinpoint device GPS coordinates with accuracy circle; fallback to default city center if permissions are denied.
- **FR-MAP-02 (Categorized Filters):** Quick filter toggles for:
  - *All Garages*
  - *Motorcycle Repair 🏍️*
  - *Car Garages 🚗*
  - *Spare Parts Stores*
- **FR-MAP-03 (Interactive Map Pins):** Custom pins indicating ratings, open/closed status, and garage type.
- **FR-MAP-04 (Shop Bottom Sheet):** Selecting a pin presents a card displaying shop name, rating, distance (km), address, operating hours, and direct action CTAs:
  - `Call Shop` (initiates tel: intent)
  - `Route / Directions` (integrates Google Maps / Apple Maps intent)
  - `View Shop & Services` (opens full shop profile)

### 4.3 Module 2: Mechanic Services Marketplace (`Page 2 — Services`)
- **FR-SRV-01 (Priority Rescue Banner):** Prominent roadside emergency dispatch card with guaranteed 15–25 min ETA for urgent battery jumpstarts, flat tire repair, and chain fixes.
- **FR-SRV-02 (Delivery Mode Switcher):** Filter listings by:
  - *All Modes*
  - *Mobile On-Site Dispatch* (mechanic travels to customer)
  - *Workshop / Garage Only*
- **FR-SRV-03 (Transparent Pricing & Scope):** Each service card displays:
  - Service title & category
  - Workshop identity & verified credentials
  - Turnaround time estimate (e.g., 30 min, 1.5 hrs)
  - Labor rate model: Fixed Fee, Base Callout + Parts, or Diagnostic Fee
  - Checklist of included tasks (e.g., "Full synthetic blend, filter change, 15-point check")
- **FR-SRV-04 (Guarantees):** Visible 30-day labor warranty and ID verification badges for trust building.

### 4.4 Module 3: Spare Parts Marketplace (`Page 3 — Store`)
- **FR-STR-01 (Search & Facets):** Keyword search bar with barcode scan capability; vehicle type switcher (All, Motorcycle, Car).
- **FR-STR-02 (Category Pills):** Brake Pads, Engine Oil, Air & Oil Filters, Batteries, Tires, Spark Plugs, Electrical, Body.
- **FR-STR-03 (Part Cards & Inventory Alerts):** Real-time stock counts (e.g., `In Stock: 10`, `Only 3 left`), genuine/OEM badges, seller shop name, and distance.
- **FR-STR-04 (Inquiry & Purchasing):** `Contact Seller` via direct call/chat and `Details` view with technical fitment compatibility.

### 4.5 Module 4: Shop & Product Management (`Page 4 — Manage`)
- **FR-MGT-01 (Shop Owner Dashboard):** Overview metrics displaying active products listed, today's map views, and direct customer inquiries.
- **FR-MGT-02 (Product CRUD Operations):**
  - **Create:** Title, price, stock count, vehicle model compatibility, category, description, and image upload.
  - **Read:** Paginated shop inventory list with search and stock badges.
  - **Update:** Inline quick-quantity adjusters (`+` / `-`), restock shortcuts, and full edit form.
  - **Delete:** Remove discontinued or sold-out items.
- **FR-MGT-03 (Service CRUD Operations):**
  - Toggle between "Parts & Items" and "Labor Services".
  - Manage service title, category, pricing model, delivery mode (In-Shop, Mobile, Both), and estimated duration.
  - "Accepting Callouts" master switch with customizable dispatch radius (e.g., 15 km).
- **FR-MGT-04 (Strict Ownership Validation):** Laravel backend guarantees that authenticated users can only mutate resources belonging to their verified `shop_id`.

### 4.6 Module 5: Profile & Settings (`Page 5 — Profile`)
- **FR-PRF-01:** Avatar management (Camera / Gallery picker), full name, verified status badge.
- **FR-PRF-02:** Quick navigation to shop working hours, physical GPS pin recalibration, and security token management.
- **FR-PRF-03 (Localization):** Real-time language switcher between English and Khmer (ភាសាខ្មែរ).
- **FR-PRF-04:** Secure logout clearing local cache and revoking API tokens.

---

## 5. System Architecture & Technical Specifications

```
  ┌────────────────────────────────────────────────────────┐
  │                 Flutter Mobile Client                  │
  │     (Provider/Riverpod, Google Maps SDK, Dio HTTP)     │
  └───────────────────────────┬────────────────────────────┘
                              │ HTTPS / JSON REST API
                              ▼
  ┌────────────────────────────────────────────────────────┐
  │                   Laravel Backend API                  │
  │   - Sanctum Auth Middleware (Token Bearer)             │
  │   - Policy / Gate Ownership Authorization              │
  │   - Spatial / Geolocation Distance Calculations        │
  └───────────────────────────┬────────────────────────────┘
                              │
                              ▼
  ┌────────────────────────────────────────────────────────┐
  │                      MySQL Database                    │
  │  users ──< shops ──< products                         │
  │             └──< mechanic_services                     │
  └────────────────────────────────────────────────────────┘
```

### 5.1 Database Entity Relationship (ERD) Schema

```sql
-- Users Table
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    profile_photo VARCHAR(255) NULL,
    role ENUM('customer', 'shop_owner', 'technician', 'admin') DEFAULT 'customer',
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- Shops Table
CREATE TABLE shops (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    description TEXT NULL,
    address VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    image VARCHAR(255) NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    accepts_callouts BOOLEAN DEFAULT TRUE,
    callout_radius_km INT DEFAULT 15,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Products Table (Physical Spare Parts)
CREATE TABLE products (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    shop_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT UNSIGNED DEFAULT 0,
    vehicle_type ENUM('motorcycle', 'car', 'universal') DEFAULT 'universal',
    category VARCHAR(100) NOT NULL,
    description TEXT NULL,
    image VARCHAR(255) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (shop_id) REFERENCES shops(id) ON DELETE CASCADE
);

-- Services Table (Mechanic Labor & Callouts)
CREATE TABLE mechanic_services (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    shop_id BIGINT UNSIGNED NOT NULL,
    title VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    service_delivery ENUM('in_shop', 'mobile_rescue', 'both') DEFAULT 'both',
    pricing_model ENUM('fixed', 'labor_rate', 'quote') DEFAULT 'fixed',
    price DECIMAL(10, 2) NOT NULL,
    estimated_minutes INT DEFAULT 30,
    motorist_guarantee JSON NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (shop_id) REFERENCES shops(id) ON DELETE CASCADE
);
```

### 5.2 Core REST API Endpoints

| Method | Endpoint | Description | Auth Required |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/register` | Register new user / shop owner | No |
| `POST` | `/api/login` | Authenticate and issue Bearer token | No |
| `GET` | `/api/user` | Fetch current user & associated shop profile | Yes |
| `GET` | `/api/shops` | Query shops with `?lat=&lng=&radius=&type=` | No |
| `POST` | `/api/shops` | Register a new repair shop | Yes |
| `PUT` | `/api/shops/{id}` | Update shop coordinates, hours, details | Yes (Owner) |
| `GET` | `/api/products` | Browse parts with `?category=&vehicle=&q=` | No |
| `POST` | `/api/products` | Add new spare part | Yes (Owner) |
| `PUT` | `/api/products/{id}` | Update product pricing / stock | Yes (Owner) |
| `DELETE`| `/api/products/{id}` | Remove product from catalog | Yes (Owner) |
| `GET` | `/api/services` | Query mechanic services by location & mode | No |
| `POST` | `/api/services` | Publish a new mechanic service | Yes (Owner) |
| `PUT` | `/api/services/{id}` | Update service details or toggle pause/resume | Yes (Owner) |
| `DELETE`| `/api/services/{id}` | Delete service offering | Yes (Owner) |

---

## 6. Non-Functional & Security Requirements

1. **Strict Authorization Validation:** All resource mutation endpoints (`PUT`, `DELETE`) are guarded by Laravel Policy checks to prevent Insecure Direct Object References (IDOR).
2. **Low-Latency Geolocation Calculations:** Spatial indexing (or the Haversine formula) in MySQL to compute nearby shops within `< 100ms` response times.
3. **Offline & Low-Bandwidth Resilience:** Optimized mobile images with progressive caching to maintain functionality on 3G/4G networks in urban and suburban environments.
4. **Localization & Accessibility:** Full UTF-8 support for Khmer font rendering, high visual contrast (WCAG AA compliant) for clear readability under bright outdoor sunlight.

---

## 7. Phased Roadmap

- **Phase 1 (Current Baseline):** 5-tab core architecture (GPS Map, Services Marketplace, Parts Store, Shop & Service Management, and Profile), guest browsing, and phone/direction intents.
- **Phase 2:** In-app real-time messaging between motorists and mechanics, live technician tracking on map during mobile dispatch.
- **Phase 3:** Integrated mobile payments (ABA PAY, KHQR, Wing, Card), automated escrow for service warranties.
- **Phase 4:** Vehicle digital maintenance logbook, scheduled servicing reminders, and loyalty garage discounts.
