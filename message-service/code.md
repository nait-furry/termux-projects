# Regex parsing: Prefer a rules-based parser...

```js

const parseMpesa = (message) => {
  const amount = message.match(/Ksh([\d,]+\.\d{2})/)?.[1];
  const recipient = message.match(/sent to ([A-Z\s']+)/i)?.[1];
  const balance = message.match(/balance is Ksh([\d,]+\.\d{2})/)?.[1];

  return { amount, recipient, balance };
};

```

# Structured Parser

```javascript
class SMSParser {
  constructor() {
    this.patterns = {
      otp: /(?:OTP|code|password)[:\s]+(\d{4,6})/i,
      amount: /(?:₹|\$|Rs\.?)\s*([\d,]+\.?\d*)/,
      transactionId: /(?:Ref|ID|TXN)[:\s#]*([A-Z0-9]{8,})/i,
      timestamp: /(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})/,
    };
  }

  parse(smsBody) {
    return {
      otp: this.extractOTP(smsBody),
      amount: this.extractAmount(smsBody),
      transactionId: this.extractTxnId(smsBody),
      timestamp: this.extractTimestamp(smsBody),
      rawBody: smsBody,
    };
  }

  extractOTP(text) {
    const match = text.match(this.patterns.otp);
    return match ? match[1] : null;
  }

  extractAmount(text) {
    const match = text.match(this.patterns.amount);
    return match ? match[1].replace(/,/g, '') : null;
  }

  extractTxnId(text) {
    const match = text.match(this.patterns.transactionId);
    return match ? match[1] : null;
  }

  extractTimestamp(text) {
    const match = text.match(this.patterns.timestamp);
    return match ? match[1] : null;
  }
}

const parser = new SMSParser();
const result = parser.parse(
  'Your OTP is 654321. Ref: TXN123ABC. Amount: $50. Date: 04/03/2026'
);
console.log(result);
// {
//   otp: '654321',
//   amount: '50',
//   transactionId: 'TXN123ABC',
//   timestamp: '04/03/2026',
//   rawBody: '...'
// }
```
**Purpose:** Build a multi-stage processing chain for robust data extraction.

```javascript
class SMSParserPipeline {
  constructor() {
    this.stages = [];
  }

  // Stage 1: Normalize
  addNormalizationStage() {
    this.stages.push((text) => {
      return text
        .trim()
        .replace(/\s+/g, ' ') // Remove extra whitespace
        .toLowerCase();
    });
    return this;
  }

  // Stage 2: Classify
  addClassificationStage() {
    this.stages.push((text) => {
      const classification = {
        isOTP: /otp|code|password|verify/.test(text),
        isTransaction: /transaction|debit|credit|amount|balance/.test(text),
        isPromo: /offer|discount|sale|limited/.test(text),
      };
      return { text, classification };
    });
    return this;
  }

  // Stage 3: Extract Entities
  addExtractionStage() {
    this.stages.push(({ text, classification }) => {
      const entities = {
        otp: this.extractOTP(text),
        amount: this.extractAmount(text),
        transactionId: this.extractTxnId(text),
        sender: this.extractSender(text),
      };
      return { text, classification, entities };
    });
    return this;
  }

  // Stage 4: Validate
  addValidationStage() {
    this.stages.push(({ text, classification, entities }) => {
      const validation = {
        isValid: true,
        errors: [],
      };

      if (classification.isOTP && !entities.otp) {
        validation.isValid = false;
        validation.errors.push('OTP expected but not found');
      }

      if (classification.isTransaction && !entities.amount) {
        validation.isValid = false;
        validation.errors.push('Amount expected but not found');
      }

      return { text, classification, entities, validation };
    });
    return this;
  }

  // Execute pipeline
  execute(input) {
    let result = input;
    for (const stage of this.stages) {
      result = stage(result);
    }
    return result;
  }

  extractOTP(text) {
    const match = text.match(/\b(\d{4,6})\b/);
    return match ? match[1] : null;
  }

  extractAmount(text) {
    const match = text.match(/(?:₹|\$|rs\.?)\s*([\d,]+\.?\d*)/);
    return match ? match[1] : null;
  }

  extractTxnId(text) {
    const match = text.match(/(?:ref|id|txn)[:\s#]*([a-z0-9]{8,})/);
    return match ? match[1] : null;
  }

  extractSender(text) {
    const match = text.match(/^from\s+(.+?):/);
    return match ? match[1] : 'Unknown';
  }
}

// Usage
const pipeline = new SMSParserPipeline()
  .addNormalizationStage()
  .addClassificationStage()
  .addExtractionStage()
  .addValidationStage();

const result = pipeline.execute(
  'Your OTP is 654321. Ref: TXN987XYZ. Amount: $100'
);
console.log(result);
```


# Parser pipeline:

### Classify message

```js
if (message.includes("Confirmed") && message.includes("Ksh")) {
  type = "mpesa_transaction";
}
```

### Extract structured fields

* amount
* recipient
* date
* balance

### Normalize

```js
{
  amount: 20.00,
  currency: "KES",
  recipient: "SAFARICOM DATA BUNDLES",
  category: "airtime"
}
```

### Store locally

* SQLite / Realm / AsyncStorage

---

# Creating personal notifications:

```js

notifee.displayNotification({
  title: 'MPESA',
  body: 'Confirmed. Ksh20.00 sent...',
  android: {
    channelId: 'transactions',
    smallIcon: 'ic_stat_name',
  },
});

```
# Notification listener service:

### Flow:

1. User enables notification access
2. Your app listens to all notifications
3. Filter:

   ```js
   if (packageName === "com.safaricom.mpesa") {
       parse(notificationText);
   }
   ```


# Accessibility Service 
* Can inspect UI
* Often rejected by Play Store if abused


# Reading Real SMS (Android)

```javascript
import { RNGetSmsAndroid } from 'react-native-get-sms-android';

const readSMS = () => {
  RNGetSmsAndroid.list(
    {
      box: 'inbox',
      maxCount: 10,
      bodyRegex: '.*OTP.*|.*code.*', // Filter for OTP messages
    },
    (fail) => console.log('Failed to retrieve SMS:', fail),
    (count, smsList) => {
      const messages = JSON.parse(smsList);
      console.log('Retrieved SMS:', messages);
      // messages = [{ _id, body, address, date }, ...]
    }
  );
};
```

# Simulating SMS Data (Testing)

```javascript
const mockSMSData = [
  {
    _id: '1',
    body: 'Your OTP is 123456. Valid for 10 minutes.',
    address: '+1234567890',
    date: Date.now(),
  },
  {
    _id: '2',
    body: 'Transaction confirmed: $50 deducted. Balance: $450',
    address: 'BANK',
    date: Date.now() - 5000,
  },
];

// Use in your app instead of real SMS
const processSMS = (messages) => {
  messages.forEach((msg) => {
    console.log(`From ${msg.address}: ${msg.body}`);
  });
};

processSMS(mockSMSData);
```


## 3. SMS-Style UI (In-App Simulation)

```javascript
import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';

const SMSSimulatorUI = () => {
  const [messages, setMessages] = useState([
    {
      id: 1,
      sender: 'BANK',
      body: 'Your OTP is 123456',
      timestamp: '2:45 PM',
      type: 'otp',
    },
    {
      id: 2,
      sender: '+1234567890',
      body: 'Transaction confirmed: $50',
      timestamp: '2:46 PM',
      type: 'transaction',
    },
  ]);

  return (
    <ScrollView style={styles.container}>
      <Text style={styles.header}>SMS Inbox (Simulated)</Text>
      {messages.map((msg) => (
        <View key={msg.id} style={styles.messageBox}>
          <View style={styles.messageHeader}>
            <Text style={styles.sender}>{msg.sender}</Text>
            <Text style={styles.time}>{msg.timestamp}</Text>
          </View>
          <Text style={styles.body}>{msg.body}</Text>
          {msg.type === 'otp' && (
            <View style={styles.otpHighlight}>
              <Text style={styles.otpText}>OTP: 123456</Text>
            </View>
          )}
        </View>
      ))}
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
    padding: 10,
  },
  header: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 15,
  },
  messageBox: {
    backgroundColor: 'white',
    borderRadius: 8,
    padding: 12,
    marginBottom: 10,
    borderLeftWidth: 4,
    borderLeftColor: '#007AFF',
  },
  messageHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 8,
  },
  sender: {
    fontWeight: '600',
    fontSize: 14,
  },
  time: {
    fontSize: 12,
    color: '#999',
  },
  body: {
    fontSize: 14,
    color: '#333',
    lineHeight: 20,
  },
  otpHighlight: {
    backgroundColor: '#fff3cd',
    borderRadius: 4,
    padding: 8,
    marginTop: 8,
  },
  otpText: {
    fontWeight: 'bold',
    color: '#856404',
  },
});

export default SMSSimulatorUI;
```

# Architecture:

## Data Sources

* SMS
* Notification Listener (preferred)
* Manual input (fallback)

## Core modules

```
/parsers
  mpesaParser.js
  bankParser.js

/services
  smsService.js
  notificationService.js

/ui
  MessageList.js
  NotificationCard.js
```


## 1) High-Level Architecture

```text
src/
 ├── app/
 │    ├── App.tsx
 │    ├── navigation/
 │
 ├── core/
 │    ├── database/        ← SQLite layer
 │    ├── models/          ← Data schemas
 │    ├── utils/           ← Helpers (formatting, regex)
 │
 ├── services/
 │    ├── sms/             ← SMS ingestion (Android)
 │    ├── notifications/   ← Local + listener service
 │    ├── parsers/         ← MPESA + generic parsers
 │
 ├── features/
 │    ├── messages/        ← Chat UI (SMS style)
 │    ├── composer/        ← Custom message generator
 │    ├── simulator/       ← Fake SMS + notification generator
 │
 ├── components/
 │    ├── MessageBubble.tsx
 │    ├── NotificationCard.tsx
 │
 ├── theme/
 │    ├── colors.ts
 │    ├── typography.ts
 │
 └── assets/
      ├── icons/           ← MPESA-like icons
```

---

# 2) Core Design Principles

### Separation of concerns

* **UI (features/components)** → rendering only
* **services/** → external inputs (SMS, notifications)
* **parsers/** → domain logic (M-PESA extraction)
* **database/** → persistence

---

# 3) Data Model (Canonical Message Format)

Everything (SMS, notifications, simulated) should normalize into ONE schema:

```ts
// core/models/Message.ts
export interface Message {
  id: string;
  source: 'sms' | 'notification' | 'simulated';
  appName: string;        // "MPESA"
  sender: string;         // "MPESA"
  body: string;

  // Parsed fields
  amount?: number;
  recipient?: string;
  balance?: number;
  type?: 'transaction' | 'airtime' | 'generic';

  timestamp: number;
}
```

---

# 4) SQLite Layer

Use:

* `react-native-sqlite-storage`

### Setup

```bash
npm install react-native-sqlite-storage
```

### Database service

```js
// core/database/db.ts
import SQLite from 'react-native-sqlite-storage';

const db = SQLite.openDatabase({ name: 'messages.db' });

export const initDB = () => {
  db.transaction(tx => {
    tx.executeSql(`
      CREATE TABLE IF NOT EXISTS messages (
        id TEXT PRIMARY KEY,
        source TEXT,
        appName TEXT,
        sender TEXT,
        body TEXT,
        amount REAL,
        recipient TEXT,
        balance REAL,
        type TEXT,
        timestamp INTEGER
      );
    `);
  });
};

export const insertMessage = (msg) => {
  db.transaction(tx => {
    tx.executeSql(
      `INSERT INTO messages VALUES (?,?,?,?,?,?,?,?,?,?)`,
      [
        msg.id,
        msg.source,
        msg.appName,
        msg.sender,
        msg.body,
        msg.amount,
        msg.recipient,
        msg.balance,
        msg.type,
        msg.timestamp,
      ]
    );
  });
};
```

---

# 5) M-PESA Parsing Pipeline

```js
// services/parsers/mpesaParser.js
export const parseMpesa = (message) => {
  if (!message.includes('Ksh')) return null;

  const amount = message.match(/Ksh([\d,]+\.\d{2})/)?.[1];
  const recipient = message.match(/sent to ([A-Z\s']+)/i)?.[1];
  const balance = message.match(/balance is Ksh([\d,]+\.\d{2})/)?.[1];

  return {
    type: 'transaction',
    amount: amount ? parseFloat(amount.replace(',', '')) : null,
    recipient,
    balance: balance ? parseFloat(balance.replace(',', '')) : null,
  };
};
```

---

# 6) SMS Service (Android)

```js
// services/sms/smsService.js
import SmsAndroid from 'react-native-get-sms-android';
import { parseMpesa } from '../parsers/mpesaParser';
import { insertMessage } from '../../core/database/db';

export const fetchSMS = () => {
  SmsAndroid.list(
    JSON.stringify({ box: 'inbox' }),
    (fail) => console.log(fail),
    (count, smsList) => {
      const messages = JSON.parse(smsList);

      messages.forEach((sms) => {
        const parsed = parseMpesa(sms.body);

        insertMessage({
          id: sms._id,
          source: 'sms',
          appName: 'MPESA',
          sender: sms.address,
          body: sms.body,
          ...parsed,
          timestamp: sms.date,
        });
      });
    }
  );
};
```

---

# 7) Notification System

## A. Local Notification Simulation

Use:

* `@notifee/react-native`

```js
// services/notifications/localNotification.js
import notifee from '@notifee/react-native';

export const triggerFakeMpesaNotification = async (body) => {
  await notifee.displayNotification({
    title: 'MPESA',
    body,
    android: {
      channelId: 'transactions',
      smallIcon: 'ic_mpesa',
    },
  });
};
```

---

## B. Notification Listener (Android Native)

This requires a **native module**.

### Concept

```java
// Android: NotificationListenerService
@Override
public void onNotificationPosted(StatusBarNotification sbn) {
    String packageName = sbn.getPackageName();
    String text = sbn.getNotification().extras.getString("android.text");

    if(packageName.contains("mpesa")) {
        // send to React Native bridge
    }
}
```

### JS bridge

```js
// services/notifications/listener.js
import { NativeEventEmitter, NativeModules } from 'react-native';

const { NotificationListener } = NativeModules;
const emitter = new NativeEventEmitter(NotificationListener);

export const startListening = () => {
  emitter.addListener('onNotification', (data) => {
    // parse and store
  });
};
```

---

# 8) Simulator (Fake SMS + Notifications)

```js
// features/simulator/simulatorService.js
import { insertMessage } from '../../core/database/db';
import { triggerFakeMpesaNotification } from '../../services/notifications/localNotification';

export const simulateTransaction = () => {
  const fakeMessage = "Confirmed. Ksh40.00 sent to GLADYS KANG'ETHE...";

  insertMessage({
    id: Date.now().toString(),
    source: 'simulated',
    appName: 'MPESA',
    sender: 'MPESA',
    body: fakeMessage,
    timestamp: Date.now(),
  });

  triggerFakeMpesaNotification(fakeMessage);
};
```

---

# 9) SMS-style UI (Core Requirement)

## Theme (M-PESA-like)

```js
// theme/colors.ts
export default {
  primary: '#00A651',   // MPESA green
  background: '#121212',
  bubbleIncoming: '#1E1E1E',
  textPrimary: '#FFFFFF',
  textSecondary: '#B0B0B0',
};
```

---

## Message Bubble

```jsx
// components/MessageBubble.tsx
import { View, Text } from 'react-native';

export default function MessageBubble({ message }) {
  return (
    <View style={{
      backgroundColor: '#1E1E1E',
      padding: 10,
      borderRadius: 12,
      marginVertical: 4,
      maxWidth: '80%',
    }}>
      <Text style={{ color: '#00A651', fontWeight: 'bold' }}>
        {message.appName}
      </Text>

      <Text style={{ color: '#FFF' }}>
        {message.body}
      </Text>

      <Text style={{ color: '#AAA', fontSize: 10 }}>
        {new Date(message.timestamp).toLocaleTimeString()}
      </Text>
    </View>
  );
}
```

---

## Message List

```jsx
// features/messages/MessageList.tsx
import { FlatList } from 'react-native';
import MessageBubble from '../../components/MessageBubble';

export default function MessageList({ messages }) {
  return (
    <FlatList
      data={messages}
      keyExtractor={(item) => item.id}
      renderItem={({ item }) => (
        <MessageBubble message={item} />
      )}
    />
  );
}
```

---

# 10) Custom Message Composer

```js
// features/composer/composerService.js
export const createCustomMpesaMessage = ({
  amount,
  recipient,
}) => {
  return `Confirmed. Ksh${amount}.00 sent to ${recipient}.`;
};
```

---

# 11) System Font Consistency

React Native defaults:

* Android → **Roboto (automatic)**
* iOS → **San Francisco**

👉 Do NOT override unless necessary:

```js
fontFamily: undefined
```

---

# 12) What You Achieve with This Architecture

✔ SMS-style UI identical to real messaging apps
✔ M-PESA-like notifications
✔ Real + simulated data ingestion
✔ Extendable parser system
✔ SQLite-backed persistence
✔ Notification listener pipeline (Android)

---



# Accessibility Service (Advanced, Risky)

### What It Can Do

- Inspect UI elements of *any* app on the device
- Read text from buttons, fields, notifications
- Simulate user interactions (clicks, text input)

### Implementation (Android)

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.BIND_ACCESSIBILITY_SERVICE" />

<service
  android:name=".MyAccessibilityService"
  android:permission="android.permission.BIND_ACCESSIBILITY_SERVICE">
  <intent-filter>
    <action android:name="android.accessibilityservice.AccessibilityService" />
  </intent-filter>
</service>
```

```java
// MyAccessibilityService.java
import android.accessibilityservice.AccessibilityService;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;

public class MyAccessibilityService extends AccessibilityService {
  @Override
  public void onAccessibilityEvent(AccessibilityEvent event) {
    AccessibilityNodeInfo source = event.getSource();
    if (source != null) {
      String text = source.getText().toString();
      Log.d("AccessibilityService", "UI Text: " + text);
      
      // Inspect child nodes
      for (int i = 0; i < source.getChildCount(); i++) {
        AccessibilityNodeInfo child = source.getChild(i);
        Log.d("AccessibilityService", "Child: " + child.getText());
      }
    }
  }

  @Override
  public void onInterrupt() {}

  @Override
  protected void onServiceConnected() {
    // Configure service
    AccessibilityServiceInfo info = new AccessibilityServiceInfo();
    info.eventTypes = AccessibilityEvent.TYPES_ALL_MASK;
    info.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC;
    setServiceInfo(info);
  }
}
```
## React-native workaround:
✅ You can create a native Android module bridging to AccessibilityService
✅ Wire it to React Native via the native bridge (like the Notification Listener example)
✅ Capture UI text, button labels, and accessibility events from other apps
✅ Simulate interactions programmatically