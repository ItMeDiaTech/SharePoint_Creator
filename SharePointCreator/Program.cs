using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.SharePoint.Client;
using System.Security;
using System.Net;
using Newtonsoft.Json;
using System.Text;
using Microsoft.SharePoint.Client;
using Newtonsoft.Json;


/*
SharePoint Modern UI Automation - C# Version
Automatically creates a complete modern SharePoint site with issue tracking,
document management, and news features using CSOM (Client Side Object Model).

NuGet Packages Required:
- Microsoft.SharePointOnline.CSOM
- Newtonsoft.Json
- System.Security.SecureString

Install via Package Manager Console:
Install-Package Microsoft.SharePointOnline.CSOM
Install-Package Newtonsoft.Json
*/

namespace SharePointAutomation
{
    public class SharePointModernAutomation
    {
        private readonly string _siteUrl;
        private readonly string _username;
        private readonly SecureString _password;
        private ClientContext _context;
        private Web _web;

        // Modern UI color scheme
        private readonly Dictionary<string, string> _themeColors = new Dictionary<string, string>
        {
            {"themePrimary", "#0078d4"},
            {"themeLighterAlt", "#eff6fc"},
            {"themeLighter", "#deecf9"},
            {"themeLight", "#c7e0f4"},
            {"themeTertiary", "#71afe5"},
            {"themeSecondary", "#2b88d8"},
            {"themeDarkAlt", "#106ebe"},
            {"themeDark", "#005a9e"},
            {"themeDarker", "#004578"},
            {"neutralLighterAlt", "#faf9f8"},
            {"neutralLighter", "#f3f2f1"},
            {"neutralLight", "#edebe9"},
            {"neutralQuaternaryAlt", "#e1dfdd"},
            {"neutralQuaternary", "#d0d0d0"},
            {"neutralTertiaryAlt", "#c8c6c4"},
            {"neutralTertiary", "#a19f9d"},
            {"neutralSecondary", "#605e5c"},
            {"neutralPrimaryAlt", "#3b3a39"},
            {"neutralPrimary", "#323130"},
            {"neutralDark", "#201f1e"},
            {"black", "#000000"},
            {"white", "#ffffff"}
        };

        public SharePointModernAutomation(string siteUrl, string username, string password)
        {
            _siteUrl = siteUrl;
            _username = username;
            _password = ConvertToSecureString(password);
        }

        private SecureString ConvertToSecureString(string password)
        {
            var securePassword = new SecureString();
            foreach (char c in password)
            {
                securePassword.AppendChar(c);
            }
            securePassword.MakeReadOnly();
            return securePassword;
        }

        public async Task<bool> ConnectToSharePoint()
        {
            try
            {
                Console.WriteLine("🔗 Connecting to SharePoint...");

                _context = new ClientContext(_siteUrl);
                _context.Credentials = new SharePointOnlineCredentials(_username, _password);

                _web = _context.Web;
                _context.Load(_web, w => w.Title, w => w.ServerRelativeUrl);
                await ExecuteQueryAsync();

                Console.WriteLine($"✓ Connected to SharePoint site: {_web.Title}");
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Connection failed: {ex.Message}");
                return false;
            }
        }

        private async Task ExecuteQueryAsync()
        {
            await Task.Run(() => _context.ExecuteQuery());
        }

        public async Task ApplyModernTheme()
        {
            Console.WriteLine("🎨 Applying modern theme...");

            try
            {
                // Modern CSS for SharePoint
                string modernCSS = @"
                <style>
                /* Modern SharePoint Theme */
                .ms-compositeHeader {
                    background-color: #ffffff !important;
                    border-bottom: 1px solid #edebe9;
                }

                .ms-siteHeader-siteLogo {
                    max-height: 40px;
                }

                .ms-webpart-chrome {
                    box-shadow: none !important;
                    border: none !important;
                    margin-bottom: 24px;
                }

                .ms-CanvasSection {
                    padding: 32px 24px;
                }

                .ms-CanvasSection:first-child {
                    padding-top: 0;
                }

                body {
                    font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, 'Roboto', sans-serif;
                    color: #323130;
                }

                h1 {
                    font-size: 48px;
                    font-weight: 600;
                    line-height: 1.2;
                    margin: 0 0 24px 0;
                    color: #323130;
                }

                h2 {
                    font-size: 32px;
                    font-weight: 600;
                    line-height: 1.25;
                    margin: 0 0 16px 0;
                    color: #323130;
                }

                h3 {
                    font-size: 24px;
                    font-weight: 600;
                    line-height: 1.33;
                    margin: 0 0 12px 0;
                    color: #323130;
                }

                p {
                    font-size: 14px;
                    line-height: 1.5;
                    margin: 0 0 16px 0;
                    color: #323130;
                }

                .hero-section {
                    background: linear-gradient(135deg, rgba(0,120,212,0.1) 0%, rgba(255,255,255,0.9) 100%);
                    padding: 64px 24px;
                    text-align: center;
                    margin-bottom: 48px;
                    border-radius: 8px;
                }

                /* Mobile optimizations */
                @media (max-width: 768px) {
                    .ms-CanvasSection { padding: 16px 12px; }
                    .ms-webpart-chrome { margin-bottom: 16px; }
                    h1 { font-size: 32px; }
                    h2 { font-size: 24px; }
                    h3 { font-size: 20px; }
                    .hero-section { padding: 32px 16px; }
                }

                /* Performance optimizations */
                .ms-webpart-chrome { will-change: transform; }
                img { max-width: 100%; height: auto; }
                </style>";

                // Add custom action for modern CSS
                var customActions = _web.UserCustomActions;
                _context.Load(customActions);
                await ExecuteQueryAsync();

                // Remove existing modern theme custom actions
                var actionsToDelete = new List<UserCustomAction>();
                foreach (var action in customActions)
                {
                    if (action.Name == "ModernThemeCSS")
                    {
                        actionsToDelete.Add(action);
                    }
                }

                foreach (var actionToDelete in actionsToDelete)
                {
                    actionToDelete.DeleteObject();
                }

                // Add new custom action
                var newAction = customActions.Add();
                newAction.Name = "ModernThemeCSS";
                newAction.Location = "ScriptLink";
                newAction.ScriptSrc = $"data:text/javascript,document.addEventListener('DOMContentLoaded',function(){{var style=document.createElement('style');style.innerHTML=`{modernCSS}`;document.head.appendChild(style);}});";
                newAction.Sequence = 1000;
                newAction.Update();

                await ExecuteQueryAsync();
                Console.WriteLine("✓ Modern theme applied successfully");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"⚠️ Theme application warning: {ex.Message}");
            }
        }

        public async Task<List> CreateIssueTrackerList()
        {
            Console.WriteLine("📋 Creating Issue Tracker list...");

            try
            {
                // Create the list
                var listCreationInfo = new ListCreationInformation
                {
                    Title = "Issue Tracker",
                    Description = "Track and manage tool issues with modern interface",
                    TemplateType = (int)ListTemplateType.GenericList
                };

                var issueList = _web.Lists.Add(listCreationInfo);
                await ExecuteQueryAsync();

                // Add custom fields
                var fieldsToAdd = new[]
                {
                    new { Name = "IssuePriority", DisplayName = "Priority", Type = FieldType.Choice,
                          Choices = new[] { "Critical", "High", "Medium", "Low" }, DefaultValue = "Medium" },
                    new { Name = "IssueStatus", DisplayName = "Status", Type = FieldType.Choice,
                          Choices = new[] { "New", "In Progress", "Resolved", "Closed" }, DefaultValue = "New" },
                    new { Name = "IssueCategory", DisplayName = "Category", Type = FieldType.Choice,
                          Choices = new[] { "Software", "Hardware", "Network", "Security", "Other" }, DefaultValue = (string)null },
                    new { Name = "AssignedTo", DisplayName = "Assigned To", Type = FieldType.User,
                          Choices = (string[])null, DefaultValue = (string)null },
                    new { Name = "DueDate", DisplayName = "Due Date", Type = FieldType.DateTime,
                          Choices = (string[])null, DefaultValue = (string)null },
                    new { Name = "ToolName", DisplayName = "Tool Name", Type = FieldType.Text,
                          Choices = (string[])null, DefaultValue = (string)null },
                    new { Name = "ImpactLevel", DisplayName = "Impact Level", Type = FieldType.Choice,
                          Choices = new[] { "High", "Medium", "Low" }, DefaultValue = (string)null }
                };

                foreach (var fieldConfig in fieldsToAdd)
                {
                    await AddFieldToList(issueList, fieldConfig.Name, fieldConfig.DisplayName,
                                       fieldConfig.Type, fieldConfig.Choices, fieldConfig.DefaultValue);
                }

                // Apply JSON formatting
                await ApplyPriorityColumnFormatting(issueList);
                await ApplyStatusColumnFormatting(issueList);

                // Create custom views
                await CreateCustomViews(issueList);

                Console.WriteLine("✓ Issue Tracker list created with custom formatting");
                return issueList;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error creating Issue Tracker: {ex.Message}");
                return null;
            }
        }

        private async Task AddFieldToList(List list, string internalName, string displayName,
                                        FieldType fieldType, string[] choices = null, string defaultValue = null)
        {
            try
            {
                string fieldXml;

                switch (fieldType)
                {
                    case FieldType.Choice:
                        var choicesXml = choices != null ? string.Join("", Array.ConvertAll(choices, c => $"<CHOICE>{c}</CHOICE>")) : "";
                        var defaultXml = !string.IsNullOrEmpty(defaultValue) ? $"<Default>{defaultValue}</Default>" : "";
                        fieldXml = $@"
                            <Field Type='Choice' Name='{internalName}' DisplayName='{displayName}' Required='FALSE'>
                                <CHOICES>{choicesXml}</CHOICES>
                                {defaultXml}
                            </Field>";
                        break;
                    case FieldType.User:
                        fieldXml = $@"<Field Type='User' Name='{internalName}' DisplayName='{displayName}' Required='FALSE'/>";
                        break;
                    case FieldType.DateTime:
                        fieldXml = $@"<Field Type='DateTime' Name='{internalName}' DisplayName='{displayName}' Required='FALSE'/>";
                        break;
                    case FieldType.Text:
                    default:
                        fieldXml = $@"<Field Type='Text' Name='{internalName}' DisplayName='{displayName}' Required='FALSE'/>";
                        break;
                }

                list.Fields.AddFieldAsXml(fieldXml, true, AddFieldOptions.DefaultValue);
                await ExecuteQueryAsync();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"⚠️ Warning adding field {internalName}: {ex.Message}");
            }
        }

        private async Task ApplyPriorityColumnFormatting(List list)
        {
            try
            {
                var priorityFormatting = new
                {
                    schema = "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
                    elmType = "div",
                    style = new { display = "flex", alignItems = "center" },
                    children = new[]
                    {
                        new
                        {
                            elmType = "span",
                            style = new
                            {
                                width = "12px",
                                height = "12px",
                                borderRadius = "50%",
                                marginRight = "8px",
                                backgroundColor = "=if(@currentField == 'Critical', '#ff4d4d', if(@currentField == 'High', '#ff9900', if(@currentField == 'Medium', '#ffcc00', '#00cc00')))"
                            }
                        },
                        new
                        {
                            elmType = "span",
                            txtContent = "@currentField",
                            style = new
                            {
                                fontWeight = "=if(@currentField == 'Critical', 'bold', 'normal')"
                            }
                        }
                    }
                };

                var field = list.Fields.GetByInternalNameOrTitle("IssuePriority");
                _context.Load(field);
                await ExecuteQueryAsync();

                field.CustomFormatter = JsonConvert.SerializeObject(priorityFormatting);
                field.Update();
                await ExecuteQueryAsync();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"⚠️ Priority formatting warning: {ex.Message}");
            }
        }

        private async Task ApplyStatusColumnFormatting(List list)
        {
            try
            {
                var statusFormatting = new
                {
                    schema = "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
                    elmType = "div",
                    style = new
                    {
                        display = "inline-block",
                        padding = "4px 12px",
                        borderRadius = "16px",
                        fontSize = "12px",
                        fontWeight = "600",
                        textTransform = "uppercase",
                        backgroundColor = "=if(@currentField == 'New', '#e1f5fe', if(@currentField == 'In Progress', '#fff3e0', if(@currentField == 'Resolved', '#e8f5e8', '#f5f5f5')))",
                        color = "=if(@currentField == 'New', '#0277bd', if(@currentField == 'In Progress', '#f57c00', if(@currentField == 'Resolved', '#388e3c', '#757575')))"
                    },
                    txtContent = "@currentField"
                };

                var field = list.Fields.GetByInternalNameOrTitle("IssueStatus");
                _context.Load(field);
                await ExecuteQueryAsync();

                field.CustomFormatter = JsonConvert.SerializeObject(statusFormatting);
                field.Update();
                await ExecuteQueryAsync();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"⚠️ Status formatting warning: {ex.Message}");
            }
        }

        private async Task CreateCustomViews(List list)
        {
            try
            {
                var views = list.Views;
                _context.Load(views);
                await ExecuteQueryAsync();

                // My Issues view
                var myIssuesViewInfo = new ViewCreationInformation
                {
                    Title = "My Issues",
                    Query = "<Where><Eq><FieldRef Name='AssignedTo'/><Value Type='Integer'><UserID/></Value></Eq></Where>",
                    ViewFields = new[] { "Title", "IssuePriority", "IssueStatus", "DueDate", "ToolName" },
                    RowLimit = 30
                };
                views.Add(myIssuesViewInfo);

                // Critical Issues view
                var criticalViewInfo = new ViewCreationInformation
                {
                    Title = "Critical Issues",
                    Query = "<Where><Eq><FieldRef Name='IssuePriority'/><Value Type='Choice'>Critical</Value></Eq></Where>",
                    ViewFields = new[] { "Title", "IssuePriority", "IssueStatus", "AssignedTo", "DueDate", "ToolName" },
                    RowLimit = 30
                };
                views.Add(criticalViewInfo);

                // Overdue Issues view
                var overdueViewInfo = new ViewCreationInformation
                {
                    Title = "Overdue Issues",
                    Query = "<Where><And><Lt><FieldRef Name='DueDate'/><Value Type='DateTime'><Today/></Value></Lt><Neq><FieldRef Name='IssueStatus'/><Value Type='Choice'>Closed</Value></Neq></And></Where>",
                    ViewFields = new[] { "Title", "IssuePriority", "IssueStatus", "AssignedTo", "DueDate", "ToolName" },
                    RowLimit = 30
                };
                views.Add(overdueViewInfo);

                await ExecuteQueryAsync();
                Console.WriteLine("✓ Custom views created");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"⚠️ View creation warning: {ex.Message}");
            }
        }

        public async Task<(List WorkLib, List ReportLib)> CreateDocumentLibraries()
        {
            Console.WriteLine("📚 Creating document libraries...");

            try
            {
                // Work Instructions Library
                var workLibInfo = new ListCreationInformation
                {
                    Title = "Work Instructions",
                    Description = "Store and manage work instruction documents",
                    TemplateType = (int)ListTemplateType.DocumentLibrary
                };

                var workLib = _web.Lists.Add(workLibInfo);
                await ExecuteQueryAsync();

                // Add metadata to Work Instructions
                var workFields = new[]
                {
                    new { Name = "Department", Display = "Department", Choices = new[] { "IT", "Engineering", "Operations", "Quality", "Safety" } },
                    new { Name = "ToolCategory", Display = "Tool Category", Choices = new[] { "Software", "Hardware", "Network", "Safety", "Maintenance" } },
                    new { Name = "VersionNumber", Display = "Version Number", Choices = (string[])null },
                    new { Name = "EffectiveDate", Display = "Effective Date", Choices = (string[])null },
                    new { Name = "ReviewDate", Display = "Review Date", Choices = (string[])null },
                    new { Name = "ApprovalStatus", Display = "Approval Status", Choices = new[] { "Draft", "Under Review", "Approved", "Archived" } }
                };

                foreach (var field in workFields)
                {
                    var fieldType = field.Choices != null ? FieldType.Choice :
                                  (field.Name.EndsWith("Date") ? FieldType.DateTime : FieldType.Text);
                    await AddFieldToList(workLib, field.Name, field.Display, fieldType, field.Choices);
                }

                // Reporting Documents Library
                var reportLibInfo = new ListCreationInformation
                {
                    Title = "Reporting Documents",
                    Description = "Store reports and analytics documents",
                    TemplateType = (int)ListTemplateType.DocumentLibrary
                };

                var reportLib = _web.Lists.Add(reportLibInfo);
                await ExecuteQueryAsync();

                // Add metadata to Reporting Documents
                var reportFields = new[]
                {
                    new { Name = "ReportType", Display = "Report Type", Choices = new[] { "Weekly", "Monthly", "Quarterly", "Annual", "Ad-hoc" } },
                    new { Name = "ReportPeriod", Display = "Report Period", Choices = (string[])null },
                    new { Name = "DataSource", Display = "Data Source", Choices = (string[])null },
                    new { Name = "DistributionList", Display = "Distribution List", Choices = (string[])null }
                };

                foreach (var field in reportFields)
                {
                    var fieldType = field.Choices != null ? FieldType.Choice :
                                  (field.Name == "DistributionList" ? FieldType.Note : FieldType.Text);
                    await AddFieldToList(reportLib, field.Name, field.Display, fieldType, field.Choices);
                }

                Console.WriteLine("✓ Document libraries created with metadata");
                return (workLib, reportLib);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error creating document libraries: {ex.Message}");
                return (null, null);
            }
        }

        public async Task CreateSampleData(List issueList)
        {
            Console.WriteLine("📊 Creating sample data...");

            try
            {
                var sampleIssues = new[]
                {
                    new Dictionary<string, object>
                    {
                        {"Title", "Database Connection Timeout"},
                        {"IssuePriority", "High"},
                        {"IssueStatus", "New"},
                        {"IssueCategory", "Software"},
                        {"ToolName", "SQL Management Studio"},
                        {"ImpactLevel", "High"},
                        {"DueDate", DateTime.Now.AddHours(24)}
                    },
                    new Dictionary<string, object>
                    {
                        {"Title", "Printer Not Responding"},
                        {"IssuePriority", "Medium"},
                        {"IssueStatus", "In Progress"},
                        {"IssueCategory", "Hardware"},
                        {"ToolName", "HP LaserJet Pro"},
                        {"ImpactLevel", "Medium"},
                        {"DueDate", DateTime.Now.AddHours(48)}
                    },
                    new Dictionary<string, object>
                    {
                        {"Title", "License Expiration Alert"},
                        {"IssuePriority", "Low"},
                        {"IssueStatus", "New"},
                        {"IssueCategory", "Software"},
                        {"ToolName", "Adobe Creative Suite"},
                        {"ImpactLevel", "Low"},
                        {"DueDate", DateTime.Now.AddHours(72)}
                    }
                };

                foreach (var issueData in sampleIssues)
                {
                    var itemInfo = new ListItemCreationInformation();
                    var newItem = issueList.AddItem(itemInfo);

                    foreach (var kvp in issueData)
                    {
                        newItem[kvp.Key] = kvp.Value;
                    }

                    newItem.Update();
                }

                await ExecuteQueryAsync();
                Console.WriteLine("✓ Sample data created");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"⚠️ Sample data creation note: {ex.Message}");
            }
        }

        public async Task OptimizePerformance()
        {
            Console.WriteLine("⚡ Applying performance optimizations...");

            try
            {
                var listsToOptimize = new[] { "Issue Tracker", "Work Instructions", "Reporting Documents" };

                foreach (var listTitle in listsToOptimize)
                {
                    try
                    {
                        var list = _web.Lists.GetByTitle(listTitle);
                        _context.Load(list);
                        await ExecuteQueryAsync();

                        // Enable modern experience
                        list.ListExperienceOptions = ListExperience.NewExperience;
                        list.Update();
                        await ExecuteQueryAsync();
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"  ⚠️ Optimization warning for {listTitle}: {ex.Message}");
                    }
                }

                Console.WriteLine("✓ Performance optimizations applied");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"⚠️ Performance optimization note: {ex.Message}");
            }
        }

        public async Task<bool> RunFullAutomation()
        {
            Console.WriteLine("🚀 Starting SharePoint Modern UI Automation...");
            Console.WriteLine(new string('=', 50));

            if (!await ConnectToSharePoint())
            {
                return false;
            }

            try
            {
                // Phase 1: Foundation
                await ApplyModernTheme();

                // Phase 2: Core Lists and Libraries
                var issueList = await CreateIssueTrackerList();
                var (workLib, reportLib) = await CreateDocumentLibraries();

                // Phase 3: Sample Data and Optimization
                if (issueList != null)
                {
                    await CreateSampleData(issueList);
                }
                await OptimizePerformance();

                // Success summary
                Console.WriteLine("\n" + new string('=', 50));
                Console.WriteLine("🎉 SHAREPOINT AUTOMATION COMPLETE!");
                Console.WriteLine(new string('=', 50));
                Console.WriteLine($"✓ Site URL: {_siteUrl}");
                Console.WriteLine("✓ Issue Tracker with JSON formatting");
                Console.WriteLine("✓ Document libraries with metadata");
                Console.WriteLine("✓ Modern theme and performance optimizations");
                Console.WriteLine("✓ Sample data for testing");

                Console.WriteLine("\n🔄 NEXT STEPS:");
                Console.WriteLine("1. Create homepage manually through SharePoint UI");
                Console.WriteLine("2. Set up navigation through Site Settings");
                Console.WriteLine("3. Configure Power Apps for issue submission");
                Console.WriteLine("4. Set up Power Automate workflows");
                Console.WriteLine("5. Add users to appropriate groups");

                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Automation failed: {ex.Message}");
                return false;
            }
            finally
            {
                _context?.Dispose();
            }
        }

        public void Dispose()
        {
            _context?.Dispose();
        }
    }

    class Program
    {
        static async Task Main(string[] args)
        {
            Console.WriteLine("SharePoint Modern UI Automation - C# Edition");
            Console.WriteLine(new string('=', 50));

            // Configuration
            Console.Write("Enter your SharePoint site URL: ");
            string siteUrl = Console.ReadLine()?.Trim();

            Console.Write("Enter your username: ");
            string username = Console.ReadLine()?.Trim();

            Console.Write("Enter your password: ");
            string password = ReadPassword();

            if (string.IsNullOrEmpty(siteUrl) || string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                Console.WriteLine("❌ Please provide all required information.");
                return;
            }

            // Create and run automation
            var automation = new SharePointModernAutomation(siteUrl, username, password);
            bool success = await automation.RunFullAutomation();

            if (success)
            {
                Console.WriteLine("\n🎯 Your modern SharePoint Tool Management Hub is ready!");
            }
            else
            {
                Console.WriteLine("\n❌ Automation encountered issues. Check the logs above.");
            }

            Console.WriteLine("\nPress any key to exit...");
            Console.ReadKey();
        }

        private static string ReadPassword()
        {
            var password = new StringBuilder();
            ConsoleKeyInfo keyInfo;

            do
            {
                keyInfo = Console.ReadKey(true);
                if (keyInfo.Key != ConsoleKey.Enter && keyInfo.Key != ConsoleKey.Backspace)
                {
                    password.Append(keyInfo.KeyChar);
                    Console.Write("*");
                }
                else if (keyInfo.Key == ConsoleKey.Backspace && password.Length > 0)
                {
                    password.Remove(password.Length - 1, 1);
                    Console.Write("\b \b");
                }
            }
            while (keyInfo.Key != ConsoleKey.Enter);

            Console.WriteLine();
            return password.ToString();
        }
    }
}