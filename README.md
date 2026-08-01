# Purchase Order Management - RAP Demo Application
Overview:

This repository contains a dummy Purchase Order Management application developed using the ABAP RESTful Application Programming Model (Managed RAP) on SAP S/4HANA.

The application demonstrates the implementation of a complete RAP application using custom database tables and dummy purchase order data. It is intended for learning, proof-of-concept (POC), and RAP development reference purposes.

Note: This application is not integrated with standard SAP MM Purchasing (EKKO/EKPO). All data is stored in custom tables.

Features
Managed RAP Business Object
Custom Header and Item Tables
CRUD Operations
Create Purchase Order
Update Purchase Order
Delete Purchase Order
Purchase Order List Report
Object Page
Search and Filter Support
Draft Handling (if enabled)
Custom Actions
Approve Purchase Order
Reject Purchase Order
Dynamic Feature Control
Enable/Disable actions based on processing status
UI Annotations using CDS
Fiori Elements Application
Dummy Purchase Order Data
Technologies Used
SAP S/4HANA
ABAP RESTful Application Programming Model (Managed RAP)
CDS Views
Behavior Definition
Behavior Implementation
Service Definition
Service Binding (OData V4)
Fiori Elements
Eclipse ADT
Application Architecture
Custom Tables
     │
     ▼
Root CDS View
     │
     ▼
Interface View
     │
     ▼
Projection View
     │
     ▼
Behavior Definition (Managed)
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
Fiori Elements UI
Database Tables
Header Table

Stores Purchase Order header information.

Example fields:

Field	Description
PurchasingDocument	Purchase Order Number
Supplier	Supplier ID
PurchasingDocumentDate	PO Date
TransactionCurrency	Currency
OverallProcessingStatus	Processing Status
TotalNetAmount	Total Amount
CreatedAt	Created Timestamp
CreatedBy	Created By
LastChangedAt	Last Changed Timestamp
LastChangedBy	Last Changed By
Item Table

Stores Purchase Order item details.

Example fields:

Field	Description
PurchasingDocument	Purchase Order Number
PurchasingDocumentItem	Item Number
Material	Material
OrderQuantity	Quantity
OrderQuantityUnit	Unit
NetPrice	Price
NetPriceCurrency	Currency
TotalPrice	Item Total
Purchase Order Status

The application supports the following dummy processing statuses.

Status	Description
O	Open
A	Approved
R	Released
C	Closed
X	Rejected
Custom Actions
Approve Purchase Order

Changes the Purchase Order status to Approved.

Action is only available when allowed by the current document status.

Reject Purchase Order

Changes the Purchase Order status to Rejected.

Action availability is controlled dynamically using RAP Feature Control.

Dynamic Feature Control

The application uses RAP Feature Control to enable or disable actions and update capability based on the Purchase Order status.

Example:

Status	Update	Approve	Reject
Open	✔	✔	✔
Approved	✖	✖	✔
Released	✖	✖	✔
Closed	✖	✖	✖
Rejected	✔	✔	✖
User Interface

The application provides a Fiori Elements List Report and Object Page.

List Report

Features include:

Purchase Order List
Smart Filter Bar
Search
Sorting
Filtering
Create
Delete
Approve
Reject
Navigation to Object Page

The list displays information such as:

Purchase Order
Supplier
Document Date
Currency
Overall Processing Status
Total Net Amount
Object Page

Displays complete Purchase Order details including:

Header Information
Item Details
Processing Status
Administrative Fields
Sample Data

The application contains dummy Purchase Orders with different statuses to demonstrate RAP functionality.

Example:

Purchase Order	Supplier	Status
21000000	V1300	Rejected
22000000	V1500	Closed
23000000	V2000	Released
24000000	V1200	Open
27000000	V3000	Approved
Project Structure
src/
│
├── Database Tables
│   ├── Header Table
│   └── Item Table
│
├── CDS
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
└── Fiori Elements
Learning Objectives

This project demonstrates:

Managed RAP Development
CDS Data Modeling
Behavior Definitions
Behavior Implementations
Actions
Feature Control
Fiori Elements
OData V4 Service Exposure
CRUD Operations
Custom Business Objects
<img width="1902" height="877" alt="image" src="https://github.com/user-attachments/assets/ff5c7f9f-de52-4cd6-b9bb-cea1842fdb19" />
