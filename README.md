# Purchase Order Management - RAP Demo Application

A simple **Purchase Order Management** application built using the **ABAP RESTful Application Programming Model (Managed RAP)** on **SAP S/4HANA**.

This project is intended as a learning/demo application that showcases end-to-end RAP development using **custom database tables** and **dummy purchase order data**. It is **not integrated with SAP MM standard tables (EKKO/EKPO)**.

---

## Features

- ✅ Managed RAP Business Object
- ✅ Custom Header & Item Tables
- ✅ CRUD Operations
- ✅ Fiori Elements List Report & Object Page
- ✅ CDS UI Annotations
- ✅ OData V2 Service
- ✅ Purchase Order Approval & Rejection Actions
- ✅ Dynamic Feature Control
- ✅ Search, Filter & Sorting
- ✅ Dummy Purchase Order Data

---

## Technology Stack

- SAP S/4HANA
- ABAP RAP (Managed)
- CDS Views
- Behavior Definition & Implementation
- Service Definition
- Service Binding (OData V2)
- Fiori Elements
- Eclipse ADT

---

## Project Structure

```
src/
│
├── Database Tables
│   ├── Purchase Order Header
│   └── Purchase Order Item
│
├── CDS Views
│   ├── Interface Views
│   ├── Projection Views
│   └── Metadata Extensions
│
├── Behavior
│   ├── Behavior Definition
│   ├── Projection Behavior
│   └── Behavior Implementation
│
├── Service
│   ├── Service Definition
│   └── Service Binding
│
└── Fiori Elements Application
```

---

## Data Model

### Purchase Order Header

| Field | Description |
|--------|-------------|
| PurchasingDocument | Purchase Order Number |
| Supplier | Supplier ID |
| PurchasingDocumentDate | Document Date |
| TransactionCurrency | Currency |
| OverallProcessingStatus | Processing Status |
| TotalNetAmount | Total Amount |

### Purchase Order Item

| Field | Description |
|--------|-------------|
| PurchasingDocument | Purchase Order Number |
| PurchasingDocumentItem | Item Number |
| Material | Material |
| OrderQuantity | Quantity |
| OrderQuantityUnit | Unit |
| NetPrice | Price |
| TotalPrice | Total Price |

---

## Processing Status

| Status | Description |
|--------|-------------|
| O | Open |
| A | Approved |
| R | Released |
| C | Closed |
| X | Rejected |

---

## Custom Actions

### Approve Purchase Order

Updates the Purchase Order status to **Approved**.

### Reject Purchase Order

Updates the Purchase Order status to **Rejected**.

Both actions are controlled dynamically using RAP Feature Control.

---

## Dynamic Feature Control

Action availability depends on the current Purchase Order status.

| Status | Update | Approve | Reject |
|--------|:------:|:-------:|:------:|
| Open | ✅ | ✅ | ✅ |
| Approved | ❌ | ❌ | ✅ |
| Released | ❌ | ❌ | ✅ |
| Closed | ❌ | ❌ | ❌ |
| Rejected | ✅ | ✅ | ❌ |

---

## Application Screens

### List Report

- Create Purchase Orders
- Delete Purchase Orders
- Approve Purchase Orders
- Reject Purchase Orders
- Smart Filter Bar
- Search
- Sorting
- Filtering
- Navigation to Object Page

### Object Page

Displays:

- Purchase Order Header
- Purchase Order Items
- Status Information
- Administrative Fields

---

## Sample Data

The application comes with dummy purchase orders having various processing statuses.

| Purchase Order | Supplier | Status |
|----------------|----------|--------|
| 21000000 | V1300 | Rejected |
| 22000000 | V1500 | Closed |
| 23000000 | V2000 | Released |
| 24000000 | V1200 | Open |
| 27000000 | V3000 | Approved |

---

## Architecture

```
Custom Tables
      │
      ▼
Root CDS View
      │
      ▼
Projection CDS
      │
      ▼
Behavior Definition
      │
      ▼
Behavior Implementation
      │
      ▼
Service Definition
      │
      ▼
Service Binding (OData V4)
      │
      ▼
Fiori Elements Application
```

---

## Learning Topics Covered

- Managed RAP Development
- CDS Data Modeling
- CRUD Operations
- RAP Actions
- Feature Control
- CDS UI Annotations
- Fiori Elements
- OData V4
- Custom Business Objects

---

## Prerequisites

- SAP S/4HANA
- Eclipse ADT
- Fiori Launchpad
- OData V4 Support

---

## Future Enhancements

- Draft Handling
- Validations
- Determinations
- Value Helps
- Attachment Management
- Workflow Integration
- Authorization Control
- Unit Tests
- Excel Export
- Analytical List Page

---

## Screenshot

<img width="1902" height="877" alt="image" src="https://github.com/user-attachments/assets/c632aa77-29bf-42a3-9e8c-474b8313b3ed" />

---

## Purpose

This repository serves as a simple reference implementation of a **Managed RAP Purchase Order application** using custom tables and dummy data. It is intended for learning, demonstrations, proof-of-concepts, and interview preparation for modern ABAP RAP development.
