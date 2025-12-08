# Figma MCP Server Setup for Cursor

This guide will help you connect Figma to Cursor using the Model Context Protocol (MCP) server.

## Option 1: Desktop MCP Server (Recommended for Local Development)

### Step 1: Enable MCP Server in Figma Desktop App

1. Open the **Figma Desktop App** (make sure it's updated to the latest version)
2. Open your Figma design file
3. Toggle to **Dev Mode** by:
   - Clicking the switch in the toolbar, OR
   - Pressing `Shift + D`
4. In the right sidebar, under the **MCP server** section, click **"Enable desktop MCP server"**
5. A confirmation message will appear
6. The server will run locally at `http://127.0.0.1:3845/mcp`

### Step 2: Configure Cursor

1. Open **Cursor**
2. Go to **Settings** (or press `Ctrl+,` / `Cmd+,`)
3. Navigate to the **MCP** tab
4. Click **"+ Add New MCP Server"**
5. Use this configuration:

```json
{
  "mcpServers": {
    "figma-desktop": {
      "url": "http://127.0.0.1:3845/mcp"
    }
  }
}
```

6. Click **"Connect"** next to the Figma MCP server
7. Follow the authentication prompts

---

## Option 2: Remote MCP Server (Cloud-based)

### Step 1: Configure Cursor

1. Open **Cursor**
2. Go to **Settings** → **MCP** tab
3. Click **"+ Add New MCP Server"**
4. Use this configuration:

```json
{
  "mcpServers": {
    "figma-remote": {
      "url": "https://mcp.figma.com/mcp"
    }
  }
}
```

5. Click **"Connect"** and authenticate

---

## Verify Connection

1. In Cursor, open the command palette (`Ctrl+Shift+P` / `Cmd+Shift+P`)
2. Search for **"MCP: Open User Configuration"** to verify the server is running
3. You should see the Figma MCP server listed

## Usage

Once connected, you can:
- Fetch Figma designs and frames
- Extract colors, typography, and design tokens
- View component specifications
- Get design assets

## Troubleshooting

- **Desktop server not working?** Make sure Figma desktop app is running and MCP server is enabled
- **Connection issues?** Check if the URL is correct and accessible
- **Authentication failed?** Try disconnecting and reconnecting the MCP server

## Reference

- [Figma MCP Server Documentation](https://developers.figma.com/docs/figma-mcp-server/)
- [Figma Desktop MCP Setup](https://help.figma.com/hc/en-us/articles/35281186390679-Figma-MCP-collection-How-to-setup-the-Figma-desktop-MCP-server)
- [Figma Remote MCP Setup](https://help.figma.com/hc/en-us/articles/35281350665623-Figma-MCP-collection-How-to-set-up-the-Figma-remote-MCP-server)

