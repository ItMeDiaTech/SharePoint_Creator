# Power Apps Connection Setup Guide

This guide provides step-by-step instructions for setting up SharePoint connections and configuring the Tool Management Hub Power Apps application.

## 📋 Prerequisites

Before starting the connection setup, ensure you have:

- [ ] Power Apps license (per-user or per-app)
- [ ] SharePoint Online site with appropriate permissions
- [ ] Site Collection Administrator rights (for list creation)
- [ ] Power Apps Maker permissions in your environment
- [ ] All SharePoint lists created as per the schema

## 🔗 SharePoint Connection Setup

### Step 1: Identify Your SharePoint Site

1. **Navigate to your SharePoint site**
2. **Copy the site URL** (format: `https://[tenant].sharepoint.com/sites/[sitename]`)
3. **Note down the exact list names** created from the schema

### Step 2: Create SharePoint Connection in Power Apps

1. **Open Power Apps Studio** (make.powerapps.com)
2. **Create a new Canvas app** or open existing app
3. **Go to Data sources** (left panel)
4. **Click "Add data"**
5. **Search for "SharePoint"**
6. **Select SharePoint**

### Step 3: Configure SharePoint Connection

1. **Enter your SharePoint site URL**:
   ```
   https://[tenant].sharepoint.com/sites/[sitename]
   ```

2. **Select the required lists**:
   - ✅ Issue Tracker
   - ✅ Tool Releases
   - ✅ Work Instructions
   - ✅ News Announcements
   - ✅ Statistics (optional)

3. **Click "Connect"**

### Step 4: Verify Connection

Test the connection by creating a simple gallery:

```powerFX
// Test formula to verify IssueTracker connection
First(IssueTracker).Title
```

If successful, you should see data or no errors in the formula bar.

## ⚙️ App Configuration

### Update Site URL Variable

In your app's **OnStart** formula, update the site URL:

```powerFX
Set(varSiteUrl, "https://[YOUR-TENANT].sharepoint.com/sites/[YOUR-SITE]");
```

**Replace:**
- `[YOUR-TENANT]` with your actual tenant name
- `[YOUR-SITE]` with your actual site name

### Configure Navigation URLs

Update the navigation URLs in the Key Items collection:

```powerFX
Set(colKeyItems,
    Table(
        {
            Icon: "📋",
            Title: "Submit Issue",
            Description: "Report a new issue for a tool",
            Action: "SubmitIssue",
            NavigationUrl: "https://[YOUR-TENANT].sharepoint.com/sites/[YOUR-SITE]/Lists/Issue%20Tracker/NewForm.aspx"
        },
        {
            Icon: "📈",
            Title: "Reports",
            Description: "Annual Review Reports, Tool Usage Reports, and more",
            Action: "Reports",
            NavigationUrl: "https://[YOUR-TENANT].sharepoint.com/sites/[YOUR-SITE]/Shared%20Documents/Reports"
        }
        // ... other items
    )
);
```

## 🔧 Work Instructions Setup

### Create Document Library

1. **Create a Document Library** named "Work Instructions" in SharePoint
2. **Upload your work instruction documents**
3. **Note the direct URLs** to each document

### Update Work Instructions List

Add entries to the Work Instructions list with correct DocumentUrl values:

| Title | Tool Name | DocumentUrl |
|-------|-----------|-------------|
| Hyperlink Fix Macro: Installation Guide | Hyperlink Fix Macro | `https://[tenant].sharepoint.com/sites/[site]/WorkInstructions/HyperlinkMacro_Install.pdf` |
| Feedback Importer Script: Setup Guide | Feedback Importer Script | `https://[tenant].sharepoint.com/sites/[site]/WorkInstructions/FeedbackImporter_Setup.pdf` |

### Test Work Instructions Links

Use this formula to test if work instruction links work:

```powerFX
LookUp(WorkInstructions,
    ToolName = "Hyperlink Fix Macro",
    DocumentUrl.Value
)
```

## 🔍 Testing Connections

### Test Data Loading

Create a button with this OnSelect formula to test all connections:

```powerFX
// Test all SharePoint connections
Set(varTestResults,
    Table(
        {
            List: "Issue Tracker",
            Status: If(IsError(First(IssueTracker)), "Error", "Success"),
            Count: CountRows(IssueTracker)
        },
        {
            List: "Tool Releases",
            Status: If(IsError(First(ToolReleases)), "Error", "Success"),
            Count: CountRows(ToolReleases)
        },
        {
            List: "Work Instructions",
            Status: If(IsError(First(WorkInstructions)), "Error", "Success"),
            Count: CountRows(WorkInstructions)
        },
        {
            List: "News Announcements",
            Status: If(IsError(First(NewsAnnouncements)), "Error", "Success"),
            Count: CountRows(NewsAnnouncements)
        }
    )
);

// Display results
UpdateContext({showTestResults: true});
```

### Test Write Operations

Test that users can submit issues:

```powerFX
// Test creating a new issue
Patch(IssueTracker,
    Defaults(IssueTracker),
    {
        Title: "Test Issue - " & Text(Now()),
        Description: "This is a test issue created from Power Apps",
        Priority: {Value: "Low"},
        Status: {Value: "Open"},
        Tool: "Power Apps Test",
        ReportedBy: {Claims: "i:0#.f|membership|" & User().Email, DisplayName: User().FullName, Email: User().Email}
    }
);

Notify("Test issue created successfully!", NotificationType.Success);
```

## 🚨 Troubleshooting Common Issues

### Connection Errors

#### Problem: "Delegation warning" appears
**Solution:**
```powerFX
// Use ClearCollect to work with large datasets
ClearCollect(colIssueTracker, IssueTracker);

// Then use the collection instead
Sort(colIssueTracker, ReportedDate, Descending)
```

#### Problem: "Data source error" in galleries
**Solution:**
1. Check SharePoint list permissions
2. Verify list names match exactly
3. Ensure lists have data
4. Test connection in Data panel

#### Problem: Navigation URLs don't work
**Solution:**
1. Check URL format and encoding
2. Test URLs directly in browser
3. Verify list/library names
4. Check SharePoint permissions

### Authentication Issues

#### Problem: "Sign in required" repeatedly appears
**Solution:**
1. **Clear browser cache and cookies**
2. **Sign out of Power Apps completely**
3. **Sign back in**
4. **Re-establish SharePoint connection**

#### Problem: Different users see different data
**Solution:**
1. **Check SharePoint list permissions**
2. **Verify Power Apps sharing settings**
3. **Review security groups and access levels**

### Performance Issues

#### Problem: App loads slowly
**Solution:**
```powerFX
// Use collections for better performance
ClearCollect(colRecentIssues,
    FirstN(
        Sort(
            Filter(IssueTracker, Status.Value <> "Closed"),
            ReportedDate,
            Descending
        ),
        10  // Limit to 10 items
    )
);
```

#### Problem: Galleries show "Loading..." indefinitely
**Solution:**
1. **Check delegation limits**
2. **Add error handling**:
```powerFX
If(IsError(IssueTracker),
    Notify("Error loading issues. Please refresh.", NotificationType.Error),
    // Normal operation
    ClearCollect(colIssueTracker, IssueTracker)
)
```

## 🔐 Security Configuration

### SharePoint List Permissions

Set up appropriate permissions for each list:

| Role | Issue Tracker | Tool Releases | Work Instructions | News |
|------|---------------|---------------|-------------------|------|
| All Users | Read/Write | Read | Read | Read |
| Power Users | Read/Write | Read/Write | Read/Write | Read |
| Administrators | Full Control | Full Control | Full Control | Full Control |

### Power Apps Sharing

1. **Go to Power Apps admin center**
2. **Select your app**
3. **Click "Share"**
4. **Add users/groups with appropriate permissions**:
   - **User**: Can use the app
   - **Co-owner**: Can edit and share the app

### Connection Security

For production environments, consider using:

1. **Service Account Connections**:
   - Create dedicated service account
   - Use for SharePoint connections
   - Reduces individual user permission dependencies

2. **Azure AD Groups**:
   - Create specific AD groups for app access
   - Manage permissions centrally

## 📊 Connection Monitoring

### Set Up Connection Health Checks

Add this to your app's OnStart to monitor connection health:

```powerFX
// Connection health monitoring
Set(varConnectionHealth,
    Table(
        {
            Source: "IssueTracker",
            Healthy: !IsError(First(IssueTracker)),
            LastCheck: Now()
        },
        {
            Source: "ToolReleases",
            Healthy: !IsError(First(ToolReleases)),
            LastCheck: Now()
        },
        {
            Source: "WorkInstructions",
            Healthy: !IsError(First(WorkInstructions)),
            LastCheck: Now()
        },
        {
            Source: "NewsAnnouncements",
            Healthy: !IsError(First(NewsAnnouncements)),
            LastCheck: Now()
        }
    )
);

// Log any connection issues
ForAll(
    Filter(varConnectionHealth, !Healthy),
    Patch('Connection Log',
        Defaults('Connection Log'),
        {
            Source: Source,
            Issue: "Connection Error",
            Timestamp: Now(),
            UserEmail: User().Email
        }
    )
);
```

### Create a Connection Status Screen

For administrators, create a screen to monitor connection health:

```powerFX
// Gallery showing connection status
Items: varConnectionHealth

// In the gallery template:
lbl_ConnectionName.Text: ThisItem.Source
lbl_ConnectionStatus.Text: If(ThisItem.Healthy, "✅ Healthy", "❌ Error")
lbl_LastCheck.Text: "Last checked: " & Text(ThisItem.LastCheck, "mm/dd/yyyy hh:mm")
```

## 🔄 Backup and Recovery

### Export App Definition

1. **Regularly export your app**:
   - Go to Power Apps maker portal
   - Select your app
   - Click "Export package"
   - Save the .zip file

2. **Document customizations**:
   - Keep track of formula changes
   - Document URL customizations
   - Note permission configurations

### Connection String Backup

Keep a record of your connection configurations:

```json
{
  "sharePointSiteUrl": "https://[tenant].sharepoint.com/sites/[site]",
  "lists": {
    "issueTracker": "Issue Tracker",
    "toolReleases": "Tool Releases",
    "workInstructions": "Work Instructions",
    "newsAnnouncements": "News Announcements"
  },
  "navigationUrls": {
    "submitIssue": "/Lists/Issue%20Tracker/NewForm.aspx",
    "reports": "/Shared%20Documents/Reports"
  }
}
```

## 📱 Environment-Specific Setup

### Development Environment

```powerFX
Set(varSiteUrl, "https://[tenant].sharepoint.com/sites/dev-toolhub");
Set(varEnvironment, "Development");
```

### Test Environment

```powerFX
Set(varSiteUrl, "https://[tenant].sharepoint.com/sites/test-toolhub");
Set(varEnvironment, "Test");
```

### Production Environment

```powerFX
Set(varSiteUrl, "https://[tenant].sharepoint.com/sites/toolhub");
Set(varEnvironment, "Production");
```

## ✅ Final Verification Checklist

Before deploying to users, verify:

- [ ] All SharePoint lists are accessible
- [ ] Sample data displays correctly
- [ ] Navigation links work
- [ ] Work instruction documents open
- [ ] Users can submit new issues
- [ ] Statistics calculate correctly
- [ ] App works on mobile devices
- [ ] Error handling displays appropriately
- [ ] Performance is acceptable
- [ ] Permissions are set correctly

## 📞 Support and Maintenance

### Regular Maintenance Tasks

1. **Monthly**:
   - Review connection health logs
   - Check for performance issues
   - Update work instruction links
   - Clean up old test data

2. **Quarterly**:
   - Review user feedback
   - Update app based on new requirements
   - Verify backup procedures
   - Test disaster recovery

3. **Annually**:
   - Review security permissions
   - Update documentation
   - Plan feature enhancements
   - Assess usage analytics

### Getting Additional Help

- **Microsoft Power Apps Documentation**: [docs.microsoft.com/powerapps](https://docs.microsoft.com/powerapps)
- **Power Apps Community**: [powerusers.microsoft.com](https://powerusers.microsoft.com)
- **SharePoint Help**: [support.microsoft.com/sharepoint](https://support.microsoft.com/sharepoint)

---

**Connection setup complete!** Your Tool Management Hub Power Apps application should now be fully connected to SharePoint and ready for use.