# Collab Code Challenge

## Overview

This project was developed as part of the **Collab Code Challenge**, a take-home assignment provided by Collab. The goal was to build a Ruby on Rails application that interacts with a mock YouTube API to fetch and display videos, allowing users to search for videos and manage playlists.

## Key Features

- **Display Videos**: Videos are displayed with their thumbnail, title and views.
- **Pagination**: The app supports pagination to navigate through pages of videos.
- **Search Functionality**: Videos can be filtered by title using a search bar.
- **Video Details Page**: Page with details including title, views, comments, likes and description.
- **Video Playback**: Iframe for playing the youtube video form the details page
- **Playlist Management**: Create playlists, add videos to playlists, and remove videos from playlists.
- **Batch Add Video to Playlists**: Add the same video to multiple playlists at the same time from the video details page
- **Batch Remove Video from Playlist**: From the Playlist page, remove multiple videos from the playlist at a time


## Technical Decisions

### Database-First Approach

Rather than interacting directly with the API for every request, the application uses a **VideoDataExtractor** to fetch video data from the API and store it in a local database. This approach was chosen for several reasons:

- **Speed**: Reading videos from the database is faster than reading from the API. Other alternative for the database would be implement async requests. 
- **Practicality**: Having the videos in the database made it easier to implement search functionality

### Learning Experience

As this was my first experience with Ruby on Rails, this project also demonstrates my ability to quickly learn and adapt to new technologies. In a short amount of time, I was able to build a fully functional application with Rails, leveraging its features and best practices.

## Deployment

One instance of this app was deployed on a Hetzner server.  
You can visit it on: http://5.78.81.254:3000

## Launching

### Option 1: Docker Compose

1. **Launch docker compose**
```bash
docker compose up
```
2. **Visit the application**:
    Navigate to http://localhost:3000 to see the app.

### Option 2: Manual install


1. **Install dependencies**:
   ```bash
   bundle install
   yarn install
   ```

2. **Set up the database**:
   ```bash
   rails db:create
   rails db:migrate
   ```

3. **Extract and Store Video Data**:
  Before running the server, you need to populate the database with video data from the mock YouTube API. Run the following command to execute the extraction job:
   ```bash
   rails runner "VideoDataExtractor.extract_and_upsert_videos"
   ```

4. **Run the server**:
   ```bash
   rails server
   ```

5. **Visit the application**:
   Open your browser and navigate to `http://localhost:3000`.

## Usage

### Home Page

- **Browsing Videos**: The home page displays a list of videos stored in the local database. Videos are shown in a grid layout with six items per row.
- **Searching Videos**: Use the search bar in the navigation menu to filter videos by title. Results are paginated and updated as you navigate.
- **Pagination**: Use the pagination controls at the bottom of the page to browse through more videos.

### Playlists

- **Creating a Playlist**: Navigate to the playlists view via the navigation menu and create a new playlist.
- **Adding Videos to a Playlist**: On the video details page, use the "Save to Playlist" button to add the video to one or more playlists via an offcanvas sidebar.
- **Removing Videos from a Playlist**: In the playlist view, switch to the "Remove Videos" mode to select and remove videos from the playlist.

## Design and Architecture

### VideoDataExtractor

The `VideoDataExtractor` class is responsible for fetching video data from the mock YouTube API and storing it in the local database. This job is run periodically or on demand to ensure that the database remains up-to-date.

```ruby
require 'httparty'

class VideoDataExtractor
  include HTTParty
  base_uri 'https://mock-youtube-api-f3d0c17f0e38.herokuapp.com/api'

  def self.extract_and_upsert_videos
    page = 1
    loop do
      response = get('/videos', query: { page: page })

      if response.success?
        videos = response['videos']

        videos.each do |video_data|
          Video.upsert({
            video_id: video_data['video_id'],
            title: video_data['title'],
            views: video_data['views'],
            likes: video_data['likes'],
            comments: video_data['comments'],
            description: video_data['description'],
            thumbnail_url: video_data['thumbnail_url'],
            created_at: video_data['created_at'],
            updated_at: video_data['updated_at']
          }, unique_by: :video_id)
        end

        break if videos.empty? || page >= response['meta']['total']

        page += 1
      else
        puts "Failed to fetch videos from API."
        break
      end
    end
  end
end
```

### Services

- **VideoService**: Interacts with the `Video` model to retrieve video data from the database.
- **PlaylistService**: Manages the creation, updating, and deletion of playlists, as well as the addition and removal of videos from playlists.

### User Interface

- **Bootstrap 5**: The application uses Bootstrap 5 for styling, ensuring a responsive and clean user interface.
- **Offcanvas Sidebar**: The playlist management feature is accessible via an offcanvas sidebar, allowing users to add or remove videos from playlists without leaving the current page.


## Conclusion

This application was built as a demonstration of my ability to quickly learn Ruby on Rails and implement a fully functional web application. The design choices made were aimed at optimizing performance, enhancing functionality, and ensuring a smooth user experience.

If you have any questions or need further information, feel free to reach out.