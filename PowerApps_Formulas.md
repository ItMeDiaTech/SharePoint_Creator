# Power Apps Formulas and Configurations

This document contains all the key formulas, configurations, and code snippets needed to build the Tool Management Hub Power Apps application.

## 🚀 App OnStart Formula

Place this in the **OnStart** property of your App:

```powerFX
// Theme Colors (Fluent UI)
Set(varThemePrimary, RGBA(0, 120, 212, 1));           // #0078d4
Set(varThemeLighterAlt, RGBA(239, 246, 252, 1));      // #eff6fc
Set(varThemeLighter, RGBA(222, 236, 249, 1));         // #deecf9
Set(varThemeLight, RGBA(199, 224, 244, 1));           // #c7e0f4
Set(varThemeDarkAlt, RGBA(16, 110, 190, 1));          // #106ebe
Set(varThemeDark, RGBA(0, 90, 158, 1));               // #005a9e

// Neutral Colors
Set(varNeutralLighterAlt, RGBA(250, 249, 248, 1));    // #faf9f8
Set(varNeutralLighter, RGBA(243, 242, 241, 1));       // #f3f2f1
Set(varNeutralLight, RGBA(237, 235, 233, 1));         // #edebe9
Set(varNeutralQuaternary, RGBA(208, 208, 208, 1));    // #d0d0d0
Set(varNeutralTertiary, RGBA(161, 159, 157, 1));      // #a19f9d
Set(varNeutralSecondary, RGBA(96, 94, 92, 1));        // #605e5c
Set(varNeutralPrimary, RGBA(50, 49, 48, 1));          // #323130
Set(varWhite, RGBA(255, 255, 255, 1));                // #ffffff

// App Configuration
Set(varSiteUrl, "https://[tenant].sharepoint.com/sites/[sitename]");
Set(varRefreshInterval, 5); // minutes
Set(varMaxGalleryItems, 10);

// Load data into collections for better performance
ClearCollect(colIssueTracker,
    Sort(IssueTracker, ReportedDate, Descending)
);

ClearCollect(colToolReleases,
    Sort(ToolReleases, ReleaseDate, Descending)
);

ClearCollect(colWorkInstructions, WorkInstructions);

ClearCollect(colNewsAnnouncements,
    Sort(
        Filter(NewsAnnouncements, IsActive = true),
        PublishDate,
        Descending
    )
);

// Set initial refresh time
Set(varLastRefresh, Now());

// Key Items static data
Set(colKeyItems,
    Table(
        {
            Icon: "📋",
            Title: "Submit Issue",
            Description: "Report a new issue for a tool",
            Action: "SubmitIssue",
            NavigationUrl: varSiteUrl & "/Lists/IssueTracker/NewForm.aspx"
        },
        {
            Icon: "📊",
            Title: "Hyperlink Fix Macro: Work Instructions",
            Description: "Work instructions on how to install, update, and troubleshoot",
            Action: "HyperlinkMacro",
            NavigationUrl: ""
        },
        {
            Icon: "📖",
            Title: "Feedback Importer Script: Work Instructions",
            Description: "Work instructions on how to install and troubleshoot",
            Action: "FeedbackScript",
            NavigationUrl: ""
        },
        {
            Icon: "📈",
            Title: "Reports",
            Description: "Annual Review Reports, Tool Usage Reports, and more",
            Action: "Reports",
            NavigationUrl: varSiteUrl & "/ReportingDocuments/Forms/AllItems.aspx"
        }
    )
);

// Initialize error state
Set(varDataLoadError, false);
```

## 📊 Statistics Calculations

### Current Status Dashboard Formula

For the **gal_Stats** gallery **Items** property:

```powerFX
[
    {
        Number: CountRows(
            Filter(colIssueTracker,
                ReportedDate >= DateAdd(Today(), -7, Days)
            )
        ),
        Label: "Issues this Week",
        Icon: "📅"
    },
    {
        Number: CountRows(
            Filter(colIssueTracker,
                ReportedDate >= DateAdd(Today(), -30, Days)
            )
        ),
        Label: "Issues this Month",
        Icon: "📆"
    },
    {
        Number: CountRows(
            Filter(colIssueTracker,
                Status.Value = "Resolved" &&
                ResolvedDate >= DateAdd(Today(), -30, Days)
            )
        ),
        Label: "Amount Resolved",
        Icon: "✅"
    },
    {
        Number: CountRows(
            Filter(colIssueTracker,
                Status.Value = "Open" || Status.Value = "In Progress"
            )
        ),
        Label: "Open Issues",
        Icon: "🔓"
    },
    {
        Number: CountRows(
            Filter(colIssueTracker,
                Status.Value = "Resolved" &&
                ResolvedDate >= DateAdd(Today(), -30, Days)
            )
        ),
        Label: "Resolved this Month",
        Icon: "🔧"
    },
    {
        Number: CountRows(
            Filter(colIssueTracker,
                Status.Value = "Resolved"
            )
        ),
        Label: "Resolved All Time",
        Icon: "🏆"
    }
]
```

### Individual Statistic Card Templates

**lbl_StatNumber** (inside stats gallery template):
```powerFX
Text(ThisItem.Number, "[$-en-US]#,##0")
```

**lbl_StatLabel** (inside stats gallery template):
```powerFX
ThisItem.Label
```

**con_StatCard** Fill property:
```powerFX
varWhite
```

**con_StatCard** BorderColor property:
```powerFX
varNeutralLight
```

## 🎯 Key Items Section

### Gallery Configuration

**gal_KeyItems** Items property:
```powerFX
colKeyItems
```

**gal_KeyItems** TemplateSize property:
```powerFX
If(App.Width > 1024, 280, If(App.Width > 768, 320, 360))
```

### Template Controls

**con_ActionCard** OnSelect property:
```powerFX
Switch(
    ThisItem.Action,
    "SubmitIssue",
        Launch(ThisItem.NavigationUrl),
    "HyperlinkMacro",
        Launch(
            LookUp(colWorkInstructions,
                ToolName = "Hyperlink Fix Macro" &&
                Category.Value = "Installation",
                DocumentUrl.Value
            )
        ),
    "FeedbackScript",
        Launch(
            LookUp(colWorkInstructions,
                ToolName = "Feedback Importer Script" &&
                Category.Value = "Installation",
                DocumentUrl.Value
            )
        ),
    "Reports",
        Launch(ThisItem.NavigationUrl)
)
```

**con_ActionCard** Fill property:
```powerFX
If(con_ActionCard.HoverFill, varNeutralLighterAlt, varWhite)
```

**con_ActionCard** HoverFill property:
```powerFX
varNeutralLighter
```

**lbl_ActionIcon** Text property:
```powerFX
ThisItem.Icon
```

**lbl_ActionTitle** Text property:
```powerFX
ThisItem.Title
```

**lbl_ActionDescription** Text property:
```powerFX
ThisItem.Description
```

## 📋 Recent Issues Section

### Gallery Configuration

**gal_RecentIssues** Items property:
```powerFX
FirstN(
    Sort(
        Filter(colIssueTracker,
            Status.Value <> "Closed"
        ),
        ReportedDate,
        Descending
    ),
    4
)
```

### Template Controls

**lbl_IssueTitle** Text property:
```powerFX
ThisItem.Title
```

**lbl_IssueMeta** Text property:
```powerFX
ThisItem.Tool & " • Reported " &
Switch(
    DateDiff(ThisItem.ReportedDate, Now(), Hours),
    0, "Just now",
    1, "1 hour ago",
    DateDiff(ThisItem.ReportedDate, Now(), Hours) < 24,
        DateDiff(ThisItem.ReportedDate, Now(), Hours) & " hours ago",
    DateDiff(ThisItem.ReportedDate, Now(), Days) = 1,
        "1 day ago",
    DateDiff(ThisItem.ReportedDate, Now(), Days) & " days ago"
)
```

**lbl_Priority** Text property:
```powerFX
Upper(ThisItem.Priority.Value)
```

**lbl_Priority** Fill property:
```powerFX
Switch(
    ThisItem.Priority.Value,
    "Critical", RGBA(255, 235, 238, 1),     // Light red background
    "High", RGBA(255, 243, 224, 1),         // Light orange background
    "Medium", RGBA(243, 229, 245, 1),       // Light purple background
    "Low", RGBA(232, 245, 232, 1),          // Light green background
    RGBA(245, 245, 245, 1)                  // Default gray
)
```

**lbl_Priority** Color property:
```powerFX
Switch(
    ThisItem.Priority.Value,
    "Critical", RGBA(198, 40, 40, 1),       // Dark red text
    "High", RGBA(239, 108, 0, 1),           // Dark orange text
    "Medium", RGBA(123, 31, 162, 1),        // Dark purple text
    "Low", RGBA(46, 125, 50, 1),            // Dark green text
    RGBA(96, 94, 92, 1)                     // Default dark gray
)
```

## 🔄 Latest Updates Section

### Gallery Configuration

**gal_LatestUpdates** Items property:
```powerFX
FirstN(
    Sort(colToolReleases, ReleaseDate, Descending),
    4
)
```

### Template Controls

**lbl_UpdateTitle** Text property:
```powerFX
ThisItem.ToolName & " " & ThisItem.Version
```

**lbl_UpdateDescription** Text property:
```powerFX
ThisItem.ReleaseNotes
```

**lbl_UpdateMeta** Text property:
```powerFX
"Released " &
Switch(
    DateDiff(ThisItem.ReleaseDate, Today(), Days),
    0, "today",
    1, "yesterday",
    DateDiff(ThisItem.ReleaseDate, Today(), Days) & " days ago"
)
```

**lbl_ReleaseStatus** Text property:
```powerFX
Upper(ThisItem.Status.Value)
```

**lbl_ReleaseStatus** Fill property:
```powerFX
Switch(
    ThisItem.Status.Value,
    "Released", RGBA(232, 245, 232, 1),     // Light green
    "Beta", RGBA(255, 243, 224, 1),         // Light orange
    "Planned", RGBA(239, 246, 252, 1),      // Light blue
    RGBA(245, 245, 245, 1)                  // Default gray
)
```

## 📰 Important News Section

### Gallery Configuration

**gal_ImportantNews** Items property:
```powerFX
FirstN(
    Sort(
        Filter(colNewsAnnouncements,
            IsActive = true &&
            PublishDate <= Today()
        ),
        PublishDate,
        Descending
    ),
    3
)
```

### Template Controls

**lbl_NewsIcon** Text property:
```powerFX
ThisItem.Icon.Value
```

**lbl_NewsTitle** Text property:
```powerFX
ThisItem.Title
```

**lbl_NewsExcerpt** Text property:
```powerFX
ThisItem.Description
```

**lbl_NewsDate** Text property:
```powerFX
Switch(
    DateDiff(ThisItem.PublishDate, Today(), Days),
    0, "Today",
    1, "Yesterday",
    DateDiff(ThisItem.PublishDate, Today(), Days) & " days ago"
)
```

## 🔄 Data Refresh Logic

### Auto-Refresh Function

Create a **Timer** control with these properties:

**tim_AutoRefresh** Duration property:
```powerFX
varRefreshInterval * 60 * 1000  // Convert minutes to milliseconds
```

**tim_AutoRefresh** OnTimerEnd property:
```powerFX
// Refresh SharePoint data
Refresh(IssueTracker);
Refresh(ToolReleases);
Refresh(NewsAnnouncements);

// Update collections
ClearCollect(colIssueTracker,
    Sort(IssueTracker, ReportedDate, Descending)
);

ClearCollect(colToolReleases,
    Sort(ToolReleases, ReleaseDate, Descending)
);

ClearCollect(colNewsAnnouncements,
    Sort(
        Filter(NewsAnnouncements, IsActive = true),
        PublishDate,
        Descending
    )
);

// Update last refresh time
Set(varLastRefresh, Now());

// Reset timer
Reset(tim_AutoRefresh);
```

### Manual Refresh Button

**btn_Refresh** OnSelect property:
```powerFX
// Show loading indicator
Set(varRefreshing, true);

// Refresh data sources
Refresh(IssueTracker);
Refresh(ToolReleases);
Refresh(WorkInstructions);
Refresh(NewsAnnouncements);

// Update collections
ClearCollect(colIssueTracker,
    Sort(IssueTracker, ReportedDate, Descending)
);

ClearCollect(colToolReleases,
    Sort(ToolReleases, ReleaseDate, Descending)
);

ClearCollect(colWorkInstructions, WorkInstructions);

ClearCollect(colNewsAnnouncements,
    Sort(
        Filter(NewsAnnouncements, IsActive = true),
        PublishDate,
        Descending
    )
);

// Update refresh time and hide loading
Set(varLastRefresh, Now());
Set(varRefreshing, false);

// Show success notification
Notify("Data refreshed successfully!", NotificationType.Success);
```

## 📱 Responsive Design Formulas

### Container Width Calculations

**con_MainContainer** Width property:
```powerFX
If(App.Width > 1200, 1200, App.Width - 48)
```

### Gallery Columns

**gal_KeyItems** TemplateSize property:
```powerFX
Switch(
    true,
    App.Width > 1024, (Parent.Width - 60) / 4,      // 4 columns on desktop
    App.Width > 768, (Parent.Width - 40) / 2,       // 2 columns on tablet
    Parent.Width - 20                                // 1 column on mobile
)
```

**gal_Stats** TemplateSize property:
```powerFX
Switch(
    true,
    App.Width > 1024, (Parent.Width - 80) / 3,      // 3 columns on desktop
    App.Width > 768, (Parent.Width - 40) / 2,       // 2 columns on tablet
    Parent.Width - 20                                // 1 column on mobile
)
```

### Font Sizes

**lbl_SiteTitle** Size property:
```powerFX
If(App.Width > 768, 32, 24)
```

**lbl_SectionTitle** Size property:
```powerFX
If(App.Width > 768, 24, 20)
```

## ⚠️ Error Handling

### Connection Error Handling

**lbl_ErrorMessage** Visible property:
```powerFX
IsError(IssueTracker) || IsError(ToolReleases) || IsError(NewsAnnouncements)
```

**lbl_ErrorMessage** Text property:
```powerFX
"Unable to load data. Please check your connection and try again."
```

### Data Validation

**gal_RecentIssues** Visible property:
```powerFX
!IsEmpty(colIssueTracker) && !varDataLoadError
```

**lbl_NoData** Visible property:
```powerFX
IsEmpty(colIssueTracker) || varDataLoadError
```

**lbl_NoData** Text property:
```powerFX
"No issues to display. Data may still be loading."
```

## 🔍 Search and Filter Functions

### Search Box Implementation

**txt_Search** OnChange property:
```powerFX
If(
    IsBlank(txt_Search.Text),
    // Show all items if search is empty
    Set(colFilteredIssues, colIssueTracker),
    // Filter based on search text
    Set(colFilteredIssues,
        Filter(colIssueTracker,
            txt_Search.Text in Title ||
            txt_Search.Text in Description ||
            txt_Search.Text in Tool
        )
    )
)
```

### Priority Filter

**drp_PriorityFilter** OnChange property:
```powerFX
If(
    drp_PriorityFilter.Selected.Value = "All",
    Set(colFilteredIssues, colIssueTracker),
    Set(colFilteredIssues,
        Filter(colIssueTracker,
            Priority.Value = drp_PriorityFilter.Selected.Value
        )
    )
)
```

## 📊 Analytics and Tracking

### User Activity Tracking

**btn_SubmitIssue** OnSelect property:
```powerFX
// Track button click
Patch('Usage Analytics',
    Defaults('Usage Analytics'),
    {
        Action: "Submit Issue Clicked",
        UserEmail: User().Email,
        Timestamp: Now(),
        ScreenName: "Home"
    }
);

// Navigate to SharePoint form
Launch(varSiteUrl & "/Lists/IssueTracker/NewForm.aspx");
```

### Performance Monitoring

**App** OnStart (additional monitoring):
```powerFX
// Track app load time
Set(varAppLoadStart, Now());

// ... existing OnStart code ...

// Record load completion
Set(varAppLoadEnd, Now());
Set(varAppLoadTime, DateDiff(varAppLoadStart, varAppLoadEnd, Milliseconds));

// Log performance data (optional)
If(varAppLoadTime > 5000,  // If load time > 5 seconds
    Patch('Performance Log',
        Defaults('Performance Log'),
        {
            LoadTime: varAppLoadTime,
            UserEmail: User().Email,
            Timestamp: Now(),
            Notes: "Slow app load detected"
        }
    )
);
```

## 🎨 Custom Styling

### Hover Effects

**con_ActionCard** OnSelect property:
```powerFX
// Add hover animation
Set(varHoverCard, ThisItem.Action);
```

**con_ActionCard** Fill property:
```powerFX
If(varHoverCard = ThisItem.Action,
    ColorFade(varThemePrimary, 95%),
    varWhite
)
```

### Loading States

**lbl_LoadingIndicator** Visible property:
```powerFX
IsEmpty(colIssueTracker) && !varDataLoadError
```

**lbl_LoadingIndicator** Text property:
```powerFX
"Loading data..."
```

### Custom Icons

**lbl_CustomIcon** Text property:
```powerFX
Switch(
    ThisItem.Category,
    "Critical", "🚨",
    "High", "⚠️",
    "Medium", "📋",
    "Low", "📝",
    "ℹ️"
)
```

This completes the comprehensive formulas and configurations needed to build the Power Apps Tool Management Hub. Each formula is designed to work with the SharePoint lists defined in the schema and provides a responsive, professional user experience.