# Solar Trailer Placement Analyzer

A web-based tool for finding optimal parking lot locations for solar trailers based on maximum sun exposure. This application helps identify parking spots that receive the most direct sunlight during a specified time period—critical for maximizing solar power generation on mobile solar installations.

## Features

- **Address Search**: Search for any address in Florida using a local database or online geocoding
- **Interactive Map**: Street and satellite view with OpenStreetMap and ArcGIS layers
- **Parking Lot Definition**: Draw custom parking lot boundaries directly on the map
- **Sun Exposure Visualization**: Real-time shadow overlay with color gradient (red = low, green = high exposure)
- **Multi-Angle Analysis**: Tests 12 orientation angles (0° to 165° in 15° increments)
- **Smart Ranking**: Returns top 10 non-overlapping spots ranked by sun exposure percentage

## Quick Start

### Running the Application

**Option 1: Python (Recommended)**
```bash
cd shademap
python -m http.server 8000
```
Then open http://localhost:8000/sun_exposure_map.html in your browser.

**Option 2: Windows Batch Script**
```
Double-click: start_server.bat
```
This will automatically find an available server (Caddy, HFS, Python, or PowerShell) and open the app.

**Option 3: PowerShell (Windows)**
```powershell
cd shademap
.\simple_server.ps1
```

> **Note**: A local HTTP server is required. Opening the HTML file directly (`file://`) will not work due to browser security restrictions.

## Getting Started

### 1. Get an API Key

The application requires a free API key from Shadow Map:
1. Visit [shademap.app/about/](https://shademap.app/about/)
2. Sign up for a free API key
3. Enter the key in the "API Key" field in the application

### 2. Search for a Location

Enter an address in the search box. The app searches:
- Local Orange County address database (faster)
- ArcGIS online geocoding (fallback)

### 3. Draw a Parking Lot

1. Click the polygon tool in the map toolbar
2. Click to create vertices around the parking lot boundary
3. Click the first point to close the polygon

### 4. Configure Analysis Settings

| Setting | Default | Description |
|---------|---------|-------------|
| **Trailer Width** | 8 ft | Width of the solar trailer |
| **Trailer Length** | 20 ft | Length of the solar trailer |
| **Grid Resolution** | 5 ft | Spacing between test positions (smaller = more accurate but slower) |
| **Max Positions** | 0 (all) | Limit analysis to N positions for faster results |
| **Start Date/Time** | Now | Beginning of analysis window |
| **End Date/Time** | +1 month | End of analysis window |
| **Detail Level** | 32 | Sun exposure calculation accuracy (8-128) |

### 5. Run Analysis

Click "Analyze Parking Lot" to find the best trailer placements. Results show:
- **Rank**: Position ranking by sun exposure
- **Sun Exposure %**: Percentage of time in direct sunlight
- **Sun Hours**: Actual hours of sunlight in the time window
- **Orientation**: Optimal trailer angle
- **Coordinates**: Lat/Long of the position

Click any result to highlight it on the map.

## How It Works

1. Generates a grid of test positions within the parking lot boundary
2. Tests each position at 12 different orientation angles
3. Filters out positions that don't fit entirely within the boundary
4. Queries the Shadow Map API for sun exposure calculations
5. Ranks results by sun exposure percentage
6. Removes overlapping placements
7. Displays the top 10 non-overlapping positions

## Technologies

- **Leaflet** - Interactive mapping
- **Shadow Map API** - Sun/shadow calculations
- **OpenStreetMap** - Map tiles and building data
- **ArcGIS** - Satellite imagery and geocoding
- **PapaParse** - CSV parsing for local address database

## Project Structure

```
shademap/
├── sun_exposure_map.html    # Main application (single-file)
├── Orlando_Address_Point.csv # Local address database
├── start_server.bat         # Windows launcher
├── simple_server.ps1        # PowerShell HTTP server
├── portable_instructions.txt # Setup guide
└── README.md                # This file
```

## Tips for Best Results

- **Smaller grid resolution** gives more accurate results but takes longer
- **Limit max positions** for faster analysis on large parking lots
- **Higher detail level** improves accuracy for complex shadow patterns
- **Longer time windows** provide better average sun exposure data
- Results are color-coded: green markers indicate the best placements

## Troubleshooting

**"CORS error" or page won't load**
- Make sure you're using a local HTTP server, not opening the file directly

**No search results**
- Try a different address format
- The local database covers Orange County, FL; other areas use online geocoding

**Analysis is slow**
- Increase grid resolution (fewer test points)
- Set a max positions limit
- Reduce the detail level

**No results found**
- Make sure the parking lot boundary is large enough for the trailer dimensions
- Check that your API key is valid

## License

This project is for educational and internal use.
