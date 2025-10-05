# 💼 Subscription Manager ## 🛠️ Quick Setup

```bash
# Install dependencies
flutter pub get

# Generate code (Hive adapters)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

👉 **New to the project?** Start with [QUICK_START.md](QUICK_START.md)

For detailed setup instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md)

**Platform:** Flutter (Android + Web)
**Storage:** Local (Hive)
**Networking:** Dio
**State Management### **F. UI / UX**

* 🧭 Bottom Navigation:

  * Home (Subscriptions)
  * Analytics
  * Payments
  * Settings
* 🌓 Light & Dark Themes (Material 3 "Material You")
* 🔍 Search & Filter by:

  * Category
  * Payment Method
  * Currency
* 💅 Clean, minimal, responsive layout for both Web and Android
* ⚡ **Lazy Loading** - All screens and heavy widgets use lazy loading for optimal performance
* 📱 Responsive design for different screen sizesency Source:** [fawazahmed0/currency-api (GitHub)](https://github.com/fawazahmed0/currency-api)
**Goal:** Manage and track subscriptions, spending analytics, and renewal reminders with offline support.

---

## �️ Quick Setup

```bash
# Install dependencies
flutter pub get

# Generate code (Hive adapters)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

For detailed setup instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md)

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| **[QUICK_START.md](QUICK_START.md)** | ⚡ Get started in 5 minutes |
| **[README.md](README.md)** | 📖 Project overview and features |
| **[TECH_STACK.md](TECH_STACK.md)** | 🛠️ Tech stack and implementation approach |
| **[WIDGETS_REFERENCE.md](WIDGETS_REFERENCE.md)** | 🎨 Shared widgets usage and examples |
| **[SETUP_GUIDE.md](SETUP_GUIDE.md)** | 🔧 Detailed setup and development guide |
| **[PROJECT_PROGRESS.md](PROJECT_PROGRESS.md)** | 📊 Feature tracking and progress |
| **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** | ✅ What's been implemented |

---

## �🚀 1. Core MVP Goals

* Let users **add, track, and analyze subscriptions**
* Support **recurring payments** (monthly, yearly, or custom durations)
* Handle **multi-currency** (USD, INR, EUR) with live conversions
* Work **offline** using locally cached data
* Provide a **modern Material 3 UI** with light/dark modes
* Use **local notifications** to remind users before renewal

---

## 📝 Documentation Guidelines

**IMPORTANT:** This project follows a minimal documentation approach.

### **Only 3 Core Documents:**
1. **README.md** - Project overview, features, and setup
2. **TECH_STACK.md** - Tech stack, libraries, UI patterns, and implementation approach
3. **PROJECT_PROGRESS.md** - Feature tracking, bugs, and project progress

**DO NOT create separate documentation for every implementation.** Keep docs simple, updated, and focused.

---

## 🧩 2. Main Features

### **A. Subscription Management**

* ➕ Add / Edit / Delete subscriptions
* Fields include:

  * Name
  * Price
  * Currency (USD / INR / EUR)
  * Category (e.g., Entertainment, Productivity, Utilities)
  * Start Date
  * Recurring Period → **Monthly / Quarterly / Yearly / Custom (e.g., every X days)**
  * Linked Payment Method
  * Optional Notes
* ⏱️ App automatically calculates the next renewal date based on recurring period
* 💰 Displays both:

  * Original currency
  * Converted amount in global selected currency

**Example:**

> Spotify Premium
> $10.00 / month (₹830.00)

---

### **B. Payment Method Tracking**

* 💳 Add payment methods (Card, UPI, PayPal, etc.)
* 🔗 Link subscriptions to payment methods
* 📋 View subscriptions filtered by payment method
* 🧾 Add notes (e.g., “Shared with family”, “Office expense”)

---

### **C. Multi-Currency System**

**Supported Currencies:** USD, INR, EUR

#### Features:

* 🌍 Global currency setting (chosen in Settings)
* 💱 Each subscription can have its own currency
* 🔄 Automatic currency conversion using **GitHub JSON rates**
* 💾 Locally cache latest fetched rates for offline use
* 🧮 All totals and analytics displayed in **global currency**

#### Data Source:

* [fawazahmed0/currency-api](https://github.com/fawazahmed0/currency-api) (via CDN)
* Example fetch URL:

  ```
  https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/usd.json
  ```
* Example cached Hive data:

  ```json
  {
    "globalCurrency": "INR",
    "currencyRates": {
      "USD": 1.0,
      "INR": 83.12,
      "EUR": 0.91
    }
  }
  ```

#### Conversion Function:

```dart
double convertCurrency({
  required double amount,
  required String from,
  required String to,
  required Map<String, double> rates,
}) {
  if (from == to) return amount;
  double amountInUSD = amount / rates[from]!;
  return amountInUSD * rates[to]!;
}
```

---

### **D. Analytics & Reports**

* 📈 Total monthly spending (in global currency)
* 🧾 Category-wise breakdown (Pie chart via `fl_chart`)
* 💳 Payment method-wise spend
* 📊 Monthly trend line chart for total spending
* 🔁 Overview of upcoming renewals

---

### **E. Notifications / Reminders**

* 🔔 Local notifications before subscription renewals

  * 3 days before
  * 1 day before
* 🔄 Automatic daily check for upcoming renewals
* 💤 Option to snooze or dismiss
* Uses `flutter_local_notifications`

---

### **F. UI / UX**

* 🧭 Bottom Navigation:

  * Home (Subscriptions)
  * Analytics
  * Payments
  * Settings
* 🌓 Light & Dark Themes (Material 3 “Material You”)
* 🔍 Search & Filter by:

  * Category
  * Payment Method
  * Currency
* 💅 Clean, minimal, responsive layout for both Web and Android

---

### **G. Settings**

* 🌍 Global Currency Selector (USD / INR / EUR)
* 🎨 Theme Toggle (Dark / Light)
* 🔔 Notification Preferences

---

## 🗂️ 3. App Architecture

### **Architecture Overview**

* **Framework:** Flutter
* **State Management:** BLoC (flutter_bloc)
* **Local Storage:** Hive
* **Networking:** Dio (to fetch GitHub JSON currency rates)
* **UI:** Material 3, responsive layout
* **Charts:** fl_chart
* **Notifications:** flutter_local_notifications

---

### **Data Storage**

```
Hive Boxes:
  subscriptionsBox
  paymentMethodsBox
  settingsBox
```

Example Hive structure:

```json
{
  "globalCurrency": "USD",
  "currencyRates": {
    "USD": 1.0,
    "INR": 83.12,
    "EUR": 0.91
  }
}
```

---

### **Folder Structure**

```
lib/
├── main.dart
├── core/
│   ├── theme/
│   ├── utils/
│   ├── constants/
├── data/
│   ├── models/
│   │   ├── subscription_model.dart
│   │   ├── payment_method_model.dart
│   │   ├── currency_rates_model.dart
│   ├── repositories/
│   │   ├── subscription_repository.dart
│   │   ├── currency_repository.dart
│   │   ├── payment_repository.dart
├── features/
│   ├── subscriptions/
│   │   ├── bloc/
│   │   ├── screens/
│   ├── payments/
│   │   ├── bloc/
│   │   ├── screens/
│   ├── analytics/
│   │   ├── bloc/
│   │   ├── screens/
│   ├── settings/
│   │   ├── bloc/
│   │   ├── screens/
│   ├── notifications/
└── widgets/
```

---

### ✅ MVP Deliverables

* Offline-ready app (Web + Android)
* Live currency conversion (USD, INR, EUR) via GitHub API
* Recurring subscription management (monthly, yearly, etc.)
* Linked payment method tracking
* Analytics dashboard with spending breakdowns
* Local renewal notifications
* Material 3 design with dark/light themes
* Global settings for currency, theme, and notifications

---

