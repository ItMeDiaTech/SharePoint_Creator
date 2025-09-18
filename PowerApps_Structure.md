# Power Apps Landing Page - Solution Structure

## App Configuration

### App Properties
- **App Name**: "Tool Management Hub"
- **App Type**: Canvas App
- **Screen Orientation**: Both (responsive)
- **Scale to Fit**: On
- **Format**: 16:9 (Standard)

### Screens Structure

#### Screen1 (Home/Landing)
Main landing page that replicates the HTML design

### Components Required

#### 1. Header Component (cmp_Header)
**Properties:**
```
- Height: 200
- Fill: RGBA(0, 120, 212, 1) // --theme-primary
- Border Radius: 0
```

**Controls:**
- **lbl_SiteTitle**: "The Good, The Bad, and The Documented"
  - Font: Segoe UI
  - Size: 24
  - Color: White
  - Weight: Bold
- **lbl_SiteSubtitle**: "Streamlined issue tracking and documentation for modern teams"
  - Font: Segoe UI
  - Size: 14
  - Color: RGBA(255,255,255,0.9)

#### 2. Key Items Section (gal_KeyItems)
**Gallery Properties:**
```
- Layout: Blank flexible height
- Items: Table of key actions
- Columns: 2 (on desktop), 1 (on mobile)
- Height: Auto-adjusting
```

**Gallery Items Data:**
```powerFX
Table(
    {
        Icon: "📋",
        Title: "Submit Issue",
        Description: "Report a new issue for a tool",
        Action: "SubmitIssue"
    },
    {
        Icon: "📊",
        Title: "Hyperlink Fix Macro: Work Instructions",
        Description: "Work instructions on how to install, update, and troubleshoot",
        Action: "HyperlinkMacro"
    },
    {
        Icon: "📖",
        Title: "Feedback Importer Script: Work Instructions",
        Description: "Work instructions on how to install and troubleshoot",
        Action: "FeedbackScript"
    },
    {
        Icon: "📈",
        Title: "Reports",
        Description: "Annual Review Reports, Tool Usage Reports, and more",
        Action: "Reports"
    }
)
```

**Gallery Template Controls:**
- **con_ActionCard**: Container with hover effects
- **lbl_Icon**: Display icon (48x48 circle)
- **lbl_Title**: Action title
- **lbl_Description**: Action description

#### 3. Current Status Dashboard (gal_Stats)
**Gallery Properties:**
```
- Layout: Blank flexible height
- Items: Statistics collection
- Columns: 3 (desktop), 2 (tablet), 1 (mobile)
```

**Data Source Formula:**
```powerFX
[
    {
        Number: CountRows(Filter(IssueTracker,
            ReportedDate >= DateAdd(Today(), -7, Days))),
        Label: "Issues this Week"
    },
    {
        Number: CountRows(Filter(IssueTracker,
            ReportedDate >= DateAdd(Today(), -30, Days))),
        Label: "Issues this Month"
    },
    {
        Number: CountRows(Filter(IssueTracker,
            Status.Value = "Resolved" &&
            ResolvedDate >= DateAdd(Today(), -30, Days))),
        Label: "Amount Resolved"
    },
    {
        Number: CountRows(Filter(IssueTracker,
            Status.Value = "Open" || Status.Value = "In Progress")),
        Label: "Open Issues"
    },
    {
        Number: CountRows(Filter(IssueTracker,
            Status.Value = "Resolved" &&
            ResolvedDate >= DateAdd(Today(), -30, Days))),
        Label: "Resolved this Month"
    },
    {
        Number: CountRows(Filter(IssueTracker,
            Status.Value = "Resolved")),
        Label: "Resolved All Time"
    }
]
```

#### 4. Latest Updates Section (gal_ToolReleases)
**Gallery Properties:**
```
- Layout: Title, subtitle, and body
- Items: Sort(ToolReleases, ReleaseDate, Descending)
- Show: First 4 items
```

**Template Controls:**
- **lbl_ReleaseTitle**: Tool name and version
- **lbl_ReleaseNotes**: Release description
- **lbl_ReleaseDate**: Formatted date
- **lbl_Status**: "Released" badge

#### 5. Recent Issues Section (gal_RecentIssues)
**Gallery Properties:**
```
- Layout: Title, subtitle, and body
- Items: Sort(Filter(IssueTracker, Status.Value <> "Closed"), ReportedDate, Descending)
- Show: First 4 items
```

**Template Controls:**
- **lbl_IssueTitle**: Issue title
- **lbl_IssueMeta**: Tool name and reported date
- **lbl_Priority**: Priority badge with color coding

**Priority Color Formula:**
```powerFX
Switch(
    ThisItem.Priority.Value,
    "Critical", RGBA(198, 40, 40, 1),
    "High", RGBA(239, 108, 0, 1),
    "Medium", RGBA(123, 31, 162, 1),
    "Low", RGBA(46, 125, 50, 1),
    RGBA(160, 160, 160, 1)
)
```

#### 6. Important News Section (gal_News)
**Gallery Properties:**
```
- Layout: Custom card layout
- Items: Sort(Filter(NewsAnnouncements, IsActive = true), PublishDate, Descending)
- Show: First 3 items
```

**Template Controls:**
- **lbl_NewsIcon**: Announcement icon
- **lbl_NewsTitle**: News title
- **lbl_NewsExcerpt**: News description
- **lbl_NewsDate**: Formatted publish date

### Color Scheme (Fluent UI Theme)
```powerFX
// Primary Colors
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
```

### Data Connections Required

#### SharePoint Connections
1. **IssueTracker** - Issue tracking list
2. **ToolReleases** - Tool release information
3. **WorkInstructions** - Work instruction documents
4. **NewsAnnouncements** - News and announcements
5. **Statistics** - Performance metrics (optional)

### Navigation Actions

#### Submit Issue Button
```powerFX
// Option 1: Navigate to SharePoint form
Launch("https://[tenant].sharepoint.com/Lists/IssueTracker/NewForm.aspx")

// Option 2: Navigate to custom form screen (if implemented)
Navigate(Screen_SubmitIssue, ScreenTransition.Fade)
```

#### Work Instructions Buttons
```powerFX
// Hyperlink Fix Macro
Launch(LookUp(WorkInstructions,
    ToolName = "Hyperlink Fix Macro",
    DocumentUrl.Value))

// Feedback Importer Script
Launch(LookUp(WorkInstructions,
    ToolName = "Feedback Importer Script",
    DocumentUrl.Value))
```

#### Reports Button
```powerFX
Launch("https://[tenant].sharepoint.com/ReportingDocuments/Forms/AllItems.aspx")
```

### Responsive Design

#### Desktop (Width > 1024)
- 4 columns for key items
- 3 columns for statistics
- 3 columns for news

#### Tablet (Width 768-1024)
- 2 columns for key items
- 2 columns for statistics
- 2 columns for news

#### Mobile (Width < 768)
- 1 column for all sections
- Larger touch targets
- Simplified layouts

### Performance Optimizations

#### Data Loading
```powerFX
// OnStart app initialization
ClearCollect(colIssueTracker, IssueTracker);
ClearCollect(colToolReleases, ToolReleases);
ClearCollect(colWorkInstructions, WorkInstructions);
ClearCollect(colNewsAnnouncements, NewsAnnouncements);

// Set refresh flag
Set(varLastRefresh, Now())
```

#### Refresh Logic
```powerFX
// Auto-refresh every 5 minutes
If(DateDiff(varLastRefresh, Now(), Minutes) > 5,
    Refresh(IssueTracker);
    Refresh(ToolReleases);
    Refresh(NewsAnnouncements);
    Set(varLastRefresh, Now())
)
```

### Error Handling

#### Connection Errors
```powerFX
If(IsError(IssueTracker),
    Notify("Unable to load issue data. Please check your connection.", NotificationType.Error),
    // Continue with normal operation
)
```

#### Fallback Data
```powerFX
// Use static data if SharePoint unavailable
If(IsEmpty(colIssueTracker),
    Set(colIssueTrackerFallback,
        Table({Title: "Unable to load data", Status: {Value: "Error"}})
    )
)
```