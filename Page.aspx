<%@ Page Language="C#" MasterPageFile="~masterurl/default.master"
     Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=16.0.0.0,
     Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
     <%@ Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls"
     Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
     <%@ Register TagPrefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages"
     Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

     <asp:Content ContentPlaceHolderId="PlaceHolderPageTitle" runat="server">
         Business Tools Hub
     </asp:Content>

     <asp:Content ContentPlaceHolderId="PlaceHolderAdditionalPageHead" runat="server">
         <meta name="viewport" content="width=device-width, initial-scale=1.0">
         <style type="text/css">
             :root {
                 --primary-color: #0078d4;
                 --secondary-color: #106ebe;
                 --success-color: #107c10;
                 --warning-color: #ffb900;
                 --danger-color: #d83b01;
                 --background: #f3f2f1;
                 --surface: #ffffff;
                 --text-primary: #323130;
                 --text-secondary: #605e5c;
                 --border-color: #edebe9;
                 --shadow: 0 2px 8px rgba(0,0,0,0.08);
                 --shadow-hover: 0 4px 16px rgba(0,0,0,0.12);
             }

             * {
                 margin: 0;
                 padding: 0;
                 box-sizing: border-box;
             }

             body {
                 font-family: "Segoe UI", -apple-system, BlinkMacSystemFont, Roboto, "Helvetica Neue", sans-serif;
                 background-color: var(--background);
                 color: var(--text-primary);
                 line-height: 1.6;
             }

             .container {
                 max-width: 1400px;
                 margin: 0 auto;
                 padding: 20px;
             }

             .hero-section {
                 background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                 color: white;
                 padding: 60px 40px;
                 border-radius: 12px;
                 margin-bottom: 40px;
                 text-align: center;
                 position: relative;
                 overflow: hidden;
             }

             .hero-section::before {
                 content: '';
                 position: absolute;
                 top: -50%;
                 right: -50%;
                 width: 200%;
                 height: 200%;
                 background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
                 background-size: 20px 20px;
                 transform: rotate(45deg);
             }

             .hero-section h1 {
                 font-size: 3em;
                 font-weight: 600;
                 margin-bottom: 15px;
                 position: relative;
                 z-index: 1;
             }

             .hero-section p {
                 font-size: 1.2em;
                 opacity: 0.95;
                 position: relative;
                 z-index: 1;
             }

             .section {
                 background: var(--surface);
                 border-radius: 12px;
                 padding: 30px;
                 margin-bottom: 30px;
                 box-shadow: var(--shadow);
             }

             .section-header {
                 display: flex;
                 align-items: center;
                 margin-bottom: 25px;
                 padding-bottom: 15px;
                 border-bottom: 2px solid var(--border-color);
             }

             .section-header h2 {
                 font-size: 1.8em;
                 font-weight: 600;
                 color: var(--text-primary);
                 margin: 0;
             }

             .section-header .icon {
                 margin-right: 15px;
                 font-size: 1.5em;
             }

             .tools-grid {
                 display: grid;
                 grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                 gap: 20px;
                 margin-top: 20px;
             }

             .tool-card {
                 background: var(--surface);
                 border: 1px solid var(--border-color);
                 border-radius: 8px;
                 padding: 20px;
                 transition: all 0.3s ease;
                 cursor: pointer;
                 position: relative;
             }

             .tool-card:hover {
                 box-shadow: var(--shadow-hover);
                 transform: translateY(-2px);
                 border-color: var(--primary-color);
             }

             .tool-card h3 {
                 color: var(--primary-color);
                 margin-bottom: 10px;
                 font-size: 1.2em;
             }

             .tool-card .description {
                 color: var(--text-secondary);
                 margin-bottom: 15px;
                 font-size: 0.95em;
             }

             .tool-card .links {
                 display: flex;
                 gap: 10px;
                 flex-wrap: wrap;
             }

             .tool-card .link-btn {
                 padding: 6px 12px;
                 background: var(--primary-color);
                 color: white;
                 text-decoration: none;
                 border-radius: 4px;
                 font-size: 0.9em;
                 transition: background 0.3s;
             }

             .tool-card .link-btn:hover {
                 background: var(--secondary-color);
             }

             .updates-container {
                 display: grid;
                 gap: 15px;
             }

             .update-item {
                 padding: 15px;
                 background: #f8f8f8;
                 border-left: 4px solid var(--primary-color);
                 border-radius: 4px;
                 transition: all 0.3s ease;
             }

             .update-item:hover {
                 background: #f0f0f0;
                 transform: translateX(5px);
             }

             .update-item .tool-name {
                 font-weight: 600;
                 color: var(--primary-color);
                 margin-bottom: 5px;
             }

             .update-item .update-date {
                 color: var(--text-secondary);
                 font-size: 0.85em;
                 margin-bottom: 8px;
             }

             .update-item .update-description {
                 color: var(--text-primary);
             }

             .issues-list {
                 display: grid;
                 gap: 12px;
             }

             .issue-item {
                 display: flex;
                 align-items: center;
                 padding: 15px;
                 background: #fff8f0;
                 border: 1px solid #ffcc80;
                 border-radius: 6px;
                 transition: all 0.3s ease;
             }

             .issue-item:hover {
                 box-shadow: 0 2px 8px rgba(255, 152, 0, 0.2);
             }

             .issue-item .issue-id {
                 background: var(--warning-color);
                 color: white;
                 padding: 4px 8px;
                 border-radius: 4px;
                 margin-right: 15px;
                 font-weight: 600;
                 font-size: 0.9em;
             }

             .issue-item .issue-title {
                 flex: 1;
                 color: var(--text-primary);
                 font-weight: 500;
             }

             .issue-item .issue-status {
                 padding: 4px 10px;
                 border-radius: 12px;
                 font-size: 0.85em;
                 font-weight: 600;
             }

             .issue-item .status-open {
                 background: #ffe0e0;
                 color: var(--danger-color);
             }

             .issue-item .status-progress {
                 background: #fff4e0;
                 color: #a86800;
             }

             .issue-item .status-resolved {
                 background: #e0f3e0;
                 color: var(--success-color);
             }

             .stats-grid {
                 display: grid;
                 grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                 gap: 20px;
             }

             .stat-card {
                 background: linear-gradient(135deg, #f5f5f5 0%, #e8e8e8 100%);
                 padding: 20px;
                 border-radius: 8px;
                 text-align: center;
                 transition: all 0.3s ease;
                 position: relative;
                 overflow: hidden;
             }

             .stat-card::before {
                 content: '';
                 position: absolute;
                 top: 0;
                 left: 0;
                 right: 0;
                 height: 4px;
                 background: var(--primary-color);
             }

             .stat-card.ongoing::before { background: var(--warning-color); }
             .stat-card.current::before { background: var(--primary-color); }
             .stat-card.implemented::before { background: var(--success-color); }

             .stat-card:hover {
                 transform: translateY(-3px);
                 box-shadow: var(--shadow-hover);
             }

             .stat-card .stat-value {
                 font-size: 2.5em;
                 font-weight: 700;
                 color: var(--primary-color);
                 margin-bottom: 5px;
             }

             .stat-card.ongoing .stat-value { color: var(--warning-color); }
             .stat-card.implemented .stat-value { color: var(--success-color); }

             .stat-card .stat-label {
                 color: var(--text-secondary);
                 font-weight: 500;
                 text-transform: uppercase;
                 font-size: 0.85em;
                 letter-spacing: 1px;
             }

             .metrics-grid {
                 display: grid;
                 grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                 gap: 20px;
             }

             .metric-card {
                 background: white;
                 border: 2px solid var(--border-color);
                 border-radius: 10px;
                 padding: 25px;
                 text-align: center;
                 transition: all 0.3s ease;
                 position: relative;
             }

             .metric-card:hover {
                 border-color: var(--primary-color);
                 box-shadow: var(--shadow-hover);
                 transform: scale(1.02);
             }

             .metric-card .metric-icon {
                 font-size: 2.5em;
                 margin-bottom: 15px;
                 background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                 -webkit-background-clip: text;
                 -webkit-text-fill-color: transparent;
                 background-clip: text;
             }

             .metric-card .metric-value {
                 font-size: 2em;
                 font-weight: 700;
                 color: var(--text-primary);
                 margin-bottom: 8px;
             }

             .metric-card .metric-label {
                 color: var(--text-secondary);
                 font-size: 0.95em;
             }

             .metric-card.highlight {
                 background: linear-gradient(135deg, #e3f2fd, #e1f5fe);
                 border-color: var(--primary-color);
             }

             .loading {
                 display: inline-block;
                 width: 20px;
                 height: 20px;
                 border: 3px solid rgba(0,0,0,.1);
                 border-radius: 50%;
                 border-top-color: var(--primary-color);
                 animation: spin 1s ease-in-out infinite;
             }

             @keyframes spin {
                 to { transform: rotate(360deg); }
             }

             .error-message {
                 background: #fde7e9;
                 color: var(--danger-color);
                 padding: 12px;
                 border-radius: 6px;
                 margin-top: 10px;
                 display: none;
             }

             @media (max-width: 768px) {
                 .container {
                     padding: 10px;
                 }

                 .hero-section h1 {
                     font-size: 2em;
                 }

                 .tools-grid {
                     grid-template-columns: 1fr;
                 }

                 .stats-grid, .metrics-grid {
                     grid-template-columns: 1fr;
                 }
             }

             .fade-in {
                 animation: fadeIn 0.5s ease-in;
             }

             @keyframes fadeIn {
                 from { opacity: 0; transform: translateY(10px); }
                 to { opacity: 1; transform: translateY(0); }
             }
         </style>
     </asp:Content>

     <asp:Content ContentPlaceHolderId="PlaceHolderMain" runat="server">
         <div class="container">
             <!-- Hero Section -->
             <div class="hero-section fade-in">
                 <h1>Business Tools Hub</h1>
                 <p>Your centralized resource for business automation tools and solutions</p>
             </div>

             <!-- Tools & Work Instructions Section -->
             <div class="section fade-in">
                 <div class="section-header">
                     <span class="icon">🛠️</span>
                     <h2>Tools & Work Instructions</h2>
                 </div>
                 <div class="tools-grid" id="toolsGrid">
                     <!-- Tools will be dynamically loaded here -->
                     <div class="loading"></div>
                 </div>
             </div>

             <!-- Recent Updates Section -->
             <div class="section fade-in">
                 <div class="section-header">
                     <span class="icon">📢</span>
                     <h2>Recent Tool Updates</h2>
                 </div>
                 <div class="updates-container" id="updatesContainer">
                     <div class="loading"></div>
                 </div>
                 <div class="error-message" id="updatesError"></div>
             </div>

             <!-- Recent Issues Section -->
             <div class="section fade-in">
                 <div class="section-header">
                     <span class="icon">⚠️</span>
                     <h2>Recent Issues (Top 5)</h2>
                 </div>
                 <div class="issues-list" id="issuesList">
                     <div class="loading"></div>
                 </div>
                 <div class="error-message" id="issuesError"></div>
             </div>

             <!-- Task Status Dashboard -->
             <div class="section fade-in">
                 <div class="section-header">
                     <span class="icon">📊</span>
                     <h2>Task Status Dashboard</h2>
                 </div>
                 <div class="stats-grid" id="taskStats">
                     <div class="stat-card ongoing">
                         <div class="stat-value" id="ongoingCount">-</div>
                         <div class="stat-label">Ongoing Tasks</div>
                     </div>
                     <div class="stat-card current">
                         <div class="stat-value" id="currentCount">-</div>
                         <div class="stat-label">Current Tasks</div>
                     </div>
                     <div class="stat-card implemented">
                         <div class="stat-value" id="implementedCount">-</div>
                         <div class="stat-label">Implemented/Solved</div>
                     </div>
                 </div>
                 <div class="error-message" id="tasksError"></div>
             </div>

             <!-- Metrics Dashboard -->
             <div class="section fade-in">
                 <div class="section-header">
                     <span class="icon">📈</span>
                     <h2>Performance Metrics</h2>
                 </div>
                 <div class="metrics-grid" id="metricsGrid">
                     <div class="metric-card">
                         <div class="metric-icon">🔗</div>
                         <div class="metric-value" id="hyperlinkMacroUses">-</div>
                         <div class="metric-label">Hyperlink Macro Total Uses</div>
                     </div>
                     <div class="metric-card">
                         <div class="metric-icon">📥</div>
                         <div class="metric-value" id="feedbackImported">-</div>
                         <div class="metric-label">Feedback Importer Total Imported</div>
                     </div>
                     <div class="metric-card">
                         <div class="metric-icon">✓</div>
                         <div class="metric-value" id="hyperlinksChecked">-</div>
                         <div class="metric-label">Hyperlinks Checked Total</div>
                     </div>
                     <div class="metric-card">
                         <div class="metric-icon">⏱️</div>
                         <div class="metric-value" id="feedbackTimeSaved">-</div>
                         <div class="metric-label">Feedback Importer Time Saved</div>
                     </div>
                     <div class="metric-card">
                         <div class="metric-icon">⏰</div>
                         <div class="metric-value" id="hyperlinkTimeSaved">-</div>
                         <div class="metric-label">Hyperlink Macro Time Saved</div>
                     </div>
                     <div class="metric-card highlight">
                         <div class="metric-icon">🎯</div>
                         <div class="metric-value" id="totalTimeSaved">-</div>
                         <div class="metric-label">All Time Saved</div>
                     </div>
                 </div>
                 <div class="error-message" id="metricsError"></div>
             </div>
         </div>

         <script type="text/javascript">
             // Configuration - Update these with your actual SharePoint URLs and list names
             const CONFIG = {
                 siteUrl: _spPageContextInfo.webAbsoluteUrl,
                 toolsListName: 'BusinessTools', // Update with your tools list name
                 updatesListName: 'ToolUpdates', // Update with your updates list name
                 issuesListName: 'Issues', // Update with your issues list name
                 tasksListName: 'Tasks', // Update with your tasks list name
                 excelFileUrl: '/sites/yoursite/Shared Documents/Metrics.xlsx', // Update with your Excel file URL
                 refreshInterval: 300000 // Refresh every 5 minutes
             };

             // Sample tools data (replace with actual SharePoint list data)
             const sampleTools = [
                 {
                     title: 'Hyperlink Macro',
                     description: 'Automates hyperlink creation and validation across documents',
                     workInstructionUrl: '#',
                     downloadUrl: '#'
                 },
                 {
                     title: 'Feedback Importer',
                     description: 'Streamlines feedback collection and processing workflow',
                     workInstructionUrl: '#',
                     downloadUrl: '#'
                 },
                 {
                     title: 'Data Validator',
                     description: 'Ensures data integrity and compliance across systems',
                     workInstructionUrl: '#',
                     downloadUrl: '#'
                 }
             ];

             // Initialize page
             document.addEventListener('DOMContentLoaded', function() {
                 loadTools();
                 loadRecentUpdates();
                 loadRecentIssues();
                 loadTaskStats();
                 loadMetrics();

                 // Set up auto-refresh
                 setInterval(function() {
                     loadRecentUpdates();
                     loadRecentIssues();
                     loadTaskStats();
                     loadMetrics();
                 }, CONFIG.refreshInterval);
             });

             // Load tools and work instructions
             function loadTools() {
                 const toolsGrid = document.getElementById('toolsGrid');

                 // For demo purposes, using sample data
                 // Replace with actual SharePoint REST API call
                 toolsGrid.innerHTML = sampleTools.map(tool => `
                     <div class="tool-card">
                         <h3>${tool.title}</h3>
                         <p class="description">${tool.description}</p>
                         <div class="links">
                             <a href="${tool.workInstructionUrl}" class="link-btn" target="_blank">��
     Instructions</a>
                             <a href="${tool.downloadUrl}" class="link-btn" target="_blank">📥 Download</a>
                         </div>
                     </div>
                 `).join('');
             }

             // Load recent updates from SharePoint list
             function loadRecentUpdates() {
                 const container = document.getElementById('updatesContainer');
                 const errorDiv = document.getElementById('updatesError');

                 // SharePoint REST API call

     fetch(`${CONFIG.siteUrl}/_api/web/lists/getbytitle('${CONFIG.updatesListName}')/items?$top=5&$orderby=Modified
     desc&$select=Title,ToolName,UpdateDescription,Modified`, {
                     method: 'GET',
                     headers: {
                         'Accept': 'application/json;odata=verbose',
                         'Content-Type': 'application/json;odata=verbose'
                     }
                 })
                 .then(response => response.json())
                 .then(data => {
                     if (data.d && data.d.results) {
                         container.innerHTML = data.d.results.map(update => `
                             <div class="update-item">
                                 <div class="tool-name">${update.ToolName}</div>
                                 <div class="update-date">${formatDate(update.Modified)}</div>
                                 <div class="update-description">${update.UpdateDescription}</div>
                             </div>
                         `).join('');
                     } else {
                         // Fallback sample data
                         container.innerHTML = `
                             <div class="update-item">
                                 <div class="tool-name">Hyperlink Macro</div>
                                 <div class="update-date">2 hours ago</div>
                                 <div class="update-description">Added batch processing capability for multiple
     documents</div>
                             </div>
                             <div class="update-item">
                                 <div class="tool-name">Feedback Importer</div>
                                 <div class="update-date">1 day ago</div>
                                 <div class="update-description">Improved error handling and validation rules</div>
                             </div>
                         `;
                     }
                     errorDiv.style.display = 'none';
                 })
                 .catch(error => {
                     console.error('Error loading updates:', error);
                     // Show sample data on error
                     container.innerHTML = `
                         <div class="update-item">
                             <div class="tool-name">Hyperlink Macro</div>
                             <div class="update-date">2 hours ago</div>
                             <div class="update-description">Added batch processing capability</div>
                         </div>
                     `;
                 });
             }

             // Load recent issues from SharePoint list
             function loadRecentIssues() {
                 const container = document.getElementById('issuesList');
                 const errorDiv = document.getElementById('issuesError');

                 // SharePoint REST API call

     fetch(`${CONFIG.siteUrl}/_api/web/lists/getbytitle('${CONFIG.issuesListName}')/items?$top=5&$orderby=Created
     desc&$select=ID,Title,Status,Priority`, {
                     method: 'GET',
                     headers: {
                         'Accept': 'application/json;odata=verbose',
                         'Content-Type': 'application/json;odata=verbose'
                     }
                 })
                 .then(response => response.json())
                 .then(data => {
                     if (data.d && data.d.results) {
                         container.innerHTML = data.d.results.map(issue => `
                             <div class="issue-item">
                                 <span class="issue-id">#${issue.ID}</span>
                                 <span class="issue-title">${issue.Title}</span>
                                 <span class="issue-status
     status-${issue.Status.toLowerCase()}">${issue.Status}</span>
                             </div>
                         `).join('');
                     } else {
                         showSampleIssues(container);
                     }
                     errorDiv.style.display = 'none';
                 })
                 .catch(error => {
                     console.error('Error loading issues:', error);
                     showSampleIssues(container);
                 });
             }

             function showSampleIssues(container) {
                 container.innerHTML = `
                     <div class="issue-item">
                         <span class="issue-id">#105</span>
                         <span class="issue-title">Excel export formatting issue in reports</span>
                         <span class="issue-status status-open">Open</span>
                     </div>
                     <div class="issue-item">
                         <span class="issue-id">#104</span>
                         <span class="issue-title">Performance optimization needed for large datasets</span>
                         <span class="issue-status status-progress">In Progress</span>
                     </div>
                     <div class="issue-item">
                         <span class="issue-id">#103</span>
                         <span class="issue-title">Update validation rules for user inputs</span>
                         <span class="issue-status status-resolved">Resolved</span>
                     </div>
                 `;
             }

             // Load task statistics from SharePoint list
             function loadTaskStats() {
                 const errorDiv = document.getElementById('tasksError');

                 // SharePoint REST API call

     fetch(`${CONFIG.siteUrl}/_api/web/lists/getbytitle('${CONFIG.tasksListName}')/items?$select=Status`, {
                     method: 'GET',
                     headers: {
                         'Accept': 'application/json;odata=verbose',
                         'Content-Type': 'application/json;odata=verbose'
                     }
                 })
                 .then(response => response.json())
                 .then(data => {
                     if (data.d && data.d.results) {
                         const stats = {
                             ongoing: 0,
                             current: 0,
                             implemented: 0
                         };

                         data.d.results.forEach(task => {
                             switch(task.Status) {
                                 case 'Ongoing':
                                     stats.ongoing++;
                                     break;
                                 case 'Current':
                                     stats.current++;
                                     break;
                                 case 'Implemented':
                                 case 'Solved':
                                     stats.implemented++;
                                     break;
                             }
                         });

                         document.getElementById('ongoingCount').textContent = stats.ongoing;
                         document.getElementById('currentCount').textContent = stats.current;
                         document.getElementById('implementedCount').textContent = stats.implemented;
                     } else {
                         setDefaultTaskStats();
                     }
                     errorDiv.style.display = 'none';
                 })
                 .catch(error => {
                     console.error('Error loading task stats:', error);
                     setDefaultTaskStats();
                 });
             }

             function setDefaultTaskStats() {
                 document.getElementById('ongoingCount').textContent = '12';
                 document.getElementById('currentCount').textContent = '8';
                 document.getElementById('implementedCount').textContent = '45';
             }

             // Load metrics from Excel file using Excel Services REST API
             function loadMetrics() {
                 const errorDiv = document.getElementById('metricsError');

                 // For SharePoint Online, you would use Microsoft Graph API or Excel Services
                 // This is a simplified example

     fetch(`${CONFIG.siteUrl}/_api/web/getfilebyserverrelativeurl('${CONFIG.excelFileUrl}')/openbinarystream`, {
                     method: 'GET',
                     headers: {
                         'Accept': 'application/json;odata=verbose'
                     }
                 })
                 .then(response => {
                     // Process Excel data here
                     // For demo purposes, using sample data
                     setDefaultMetrics();
                     errorDiv.style.display = 'none';
                 })
                 .catch(error => {
                     console.error('Error loading metrics:', error);
                     setDefaultMetrics();
                 });
             }

             function setDefaultMetrics() {
                 document.getElementById('hyperlinkMacroUses').textContent = '2,456';
                 document.getElementById('feedbackImported').textContent = '8,932';
                 document.getElementById('hyperlinksChecked').textContent = '15,678';
                 document.getElementById('feedbackTimeSaved').textContent = '186 hrs';
                 document.getElementById('hyperlinkTimeSaved').textContent = '234 hrs';
                 document.getElementById('totalTimeSaved').textContent = '420 hrs';
             }

             // Utility function to format dates
             function formatDate(dateString) {
                 const date = new Date(dateString);
                 const now = new Date();
                 const diffMs = now - date;
                 const diffHours = Math.floor(diffMs / (1000 * 60 * 60));

                 if (diffHours < 1) {
                     const diffMins = Math.floor(diffMs / (1000 * 60));
                     return `${diffMins} minutes ago`;
                 } else if (diffHours < 24) {
                     return `${diffHours} hours ago`;
                 } else {
                     const diffDays = Math.floor(diffHours / 24);
                     return `${diffDays} days ago`;
                 }
             }

             // Add animation on scroll
             const observerOptions = {
                 threshold: 0.1,
                 rootMargin: '0px 0px -50px 0px'
             };

             const observer = new IntersectionObserver((entries) => {
                 entries.forEach(entry => {
                     if (entry.isIntersecting) {
                         entry.target.classList.add('fade-in');
                         observer.unobserve(entry.target);
                     }
                 });
             }, observerOptions);

             document.querySelectorAll('.section').forEach(section => {
                 observer.observe(section);
             });
         </script>
     </asp:Content>