A Swift app built with ARKit and GitHub's API, allowing users to search for GitHub profiles, view followers, and manage a list of favorite users. Users can also navigate to public profiles through an in-app Safari browser.

## Features

1. **GitHub User Search**  
   - Users can search for a GitHub user by their username.
   - Displays a list of followers for the searched user.
   - Each follower can be selected to view detailed public information.
   - <img src="https://github.com/user-attachments/assets/01011c44-f9a9-4019-83d8-1a416228522c" width="200">  <img src="https://github.com/user-attachments/assets/7f2379d4-2a36-49c5-a0a5-079c9c1a5405" width="200"> 

2. **Follower Navigation**  
   - Users can click on a follower to view their public GitHub information.
   - Includes an option to open the selected user's GitHub profile directly in an in-app Safari browser.
   - Allows searching the follower’s followers for deeper profile exploration.
   - <img src="https://github.com/user-attachments/assets/70583997-75e7-4ab5-96da-3ab24f60d062" width="200"> <img src="https://github.com/user-attachments/assets/269c9f57-bdb7-4641-895f-5ab3d0fd22ce" width="200">


3. **Favorites List**  
   - Users can add any searched GitHub profile to a personal favorites list.
   - A second navigation view displays all the users added to the favorites list.
   - <img src="https://github.com/user-attachments/assets/16eea495-48c1-48d9-a66b-9886307cafc9" width="200">

## App Structure

- **Search View**:  
  Allows users to search for a GitHub profile by entering a username. Once a user is found, a list of their followers is displayed. Selecting a follower opens more detailed information about them.

- **Follower Details View**:  
  Displays the selected follower's public GitHub information such as repositories, bio, and profile picture. Includes a button to open their GitHub profile in an in-app Safari browser. Also supports searching the selected follower's followers.

- **Favorites View**:  
  Displays all GitHub users the user has added to their favorites list, allowing easy access to profiles they want to revisit.

## Technologies Used

- **ARKit**: Used for augmented reality features within the app.
- **GitHub API**: Retrieves user profiles, followers, and public information.
- **Safari Services (SFSafariViewController)**: Displays GitHub profiles directly in the app using Safari.
- **UserDefaults**: Stores and retrieves favorite GitHub users.

## Installation and Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/github-user-search-app.git
