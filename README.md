# CryptoTracker App

## Project overview
CryptoTracker is a comprehensive mobile application designed to keep you informed about cryptocurrency markets. It allows users to track real-time prices, set up alerts for price changes, and analyze historical price data through detailed charts.

## Features
- **Real-Time Price Tracking**: Stay updated with live prices of a wide range of cryptocurrencies. The app ensures that you get the latest market data at your fingertips.
- **Interactive Price Charts**: Access detailed historical price charts to analyze trends and make informed decisions. The charts are designed to be intuitive and provide valuable insights into market behavior.
- **Favorites Management**: Easily track your favorite cryptocurrencies by adding them to your favorites list. Quickly access their current prices and market trends from a dedicated section in the app.

## Usage
1. **Home Screen**: Upon launching the app, you will see a list of cryptocurrencies with their current prices. Use the search function to find specific coins quickly.
2. **Detailed View**: Tap on any cryptocurrency to view more detailed information, including historical price charts and market statistics.
3. **Favorites**: Add coins to your favorites by selecting the star icon next to their names. Access your favorites from the dedicated tab to keep track of the coins you care about the most.

## Technologies
- **Flutter**: Utilized for building a responsive and user-friendly mobile interface. 
- **RESTful API Integration**: Provides real-time cryptocurrency data from reliable sources.

## Screenshots

    <style>
        .screenshot-table img {
            width: 100%;
            max-width: 200px;
            height: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
        }
        th {
            background-color: #f4f4f4;
        }
    </style>

    <button onclick="switchTheme('LightTheme')">Light Theme</button>
    <button onclick="switchTheme('DarkTheme')">Dark Theme</button>

    <div class="screenshot-table">
        <h2>Screenshots</h2>
        <table>
            <thead>
                <tr>
                    <th>Homepage Screenshots</th>
                    <th></th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><img id="homepageFavorite" src="" alt="Homepage Favorite"></td>
                    <td><img id="homepageMarkets1" src="" alt="Homepage Markets 1"></td>
                    <td><img id="homepageMarkets2" src="" alt="Homepage Markets 2"></td>
                </tr>
                <tr>
                    <th>Other Screenshots</th>
                    <th></th>
                    <th></th>
                </tr>
                <tr>
                    <td><img id="details15Day" src="" alt="Details 15 Day"></td>
                    <td><img id="details1Day" src="" alt="Details 1 Day"></td>
                    <td><img id="details7Day" src="" alt="Details 7 Day"></td>
                </tr>
            </tbody>
        </table>
    </div>

    <script>
        let currentTheme = 'LightTheme';

        function switchTheme(theme) {
            currentTheme = theme;
            updateImages();
        }

        function updateImages() {
            document.getElementById('homepageFavorite').src = `Screenshots/${currentTheme}/HomepageFavorite.png`;
            document.getElementById('homepageMarkets1').src = `Screenshots/${currentTheme}/HomepageMarkets1.png`;
            document.getElementById('homepageMarkets2').src = `Screenshots/${currentTheme}/HomepageMarkets2.png`;
            document.getElementById('details15Day').src = `Screenshots/${currentTheme}/Details15Day.png`;
            document.getElementById('details1Day').src = `Screenshots/${currentTheme}/Details1Day.png`;
            document.getElementById('details7Day').src = `Screenshots/${currentTheme}/Details7Day.png`;
        }

        // Initialize with the default theme
        updateImages();
    </script>



