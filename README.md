# Power-BI-Enterprise-Analytics

# 🚀 From Excel Limits to Enterprise Analytics with Microsoft Fabric

Just wrapped a Microsoft Fabric implementation that replaced a manual, fragile reporting process with a fully automated analytics platform.

---

## ⚠️ The Problem

Data scattered across Excel files and SQL Server. Slow, manual refreshes. No alerting. No single source of truth.

> **The hardest part was making messy real-world data behave across two completely different sources.**

---

## 🏗️ The Solution: Medallion Architecture in Microsoft Fabric

### 🔹 Bronze Layer
Connected on-premises SQL Server through an On-Premises Data Gateway and ingested raw data using **Dataflow Gen2** and **Copy Activities** into the Lakehouse.

### 🔹 Silver Layer
Cleaned, standardized, and reconciled data from both sources.

### 🔹 Gold Layer
Curated, analytics-ready datasets prepared for reporting and analysis.

---

## 📊 Analytics Layer

Built a **star schema data model**, published a **semantic model** with optimized relationships and DAX measures, and delivered an interactive executive sales dashboard in Power BI tracking **$80.45M in total sales**.

---

## ⚙️ Automation & Governance

Fully orchestrated pipeline with automated scheduling and failure alerts.

---

## 💡 Business Impact

| # | Impact |
|---|--------|
| ✅ | $80.45M in sales now visible in one unified dashboard |
| ✅ | 19,000+ customer records automated with zero manual intervention |
| ✅ | Reduced reporting time from days to minutes |
| ✅ | Single source of truth across all data sources |
| ✅ | Deeper visibility into sales trends, products & KPIs |
| ✅ | Eliminated manual reporting effort, freeing time for actual analysis and decision-making |

---

## 🔑 Key Takeaway

What stood out most was how **Microsoft Fabric unified ingestion, transformation, warehousing, orchestration, and reporting — all in one platform.**

---

## 🛠️ Tools & Technologies

![Microsoft Fabric](https://img.shields.io/badge/Microsoft%20Fabric-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)

---

## 📁 Architecture Overview

| Layer | Purpose | Tools Used |
|-------|---------|------------|
| **Bronze** | Raw ingestion | Dataflow Gen2, Copy Activities, On-Premises Data Gateway |
| **Silver** | Cleansing & standardization | Microsoft Fabric Lakehouse |
| **Gold** | Business-ready datasets | Microsoft Fabric Warehouse |
| **Analytics** | Reporting & insights | Power BI, Semantic Model, DAX |
| **Orchestration** | Automation & monitoring | Fabric Data Pipeline, Scheduled Triggers |


![Architecture Overview](https://github.com/Donatus-Victor/Power-BI-Enterprise-Analytics/blob/main/ARCHITECTURE.jpg?raw=true)


