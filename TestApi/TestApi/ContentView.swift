//
//  ContentView.swift
//  TestApi
//
//  Created by Siddhatech on 26/08/24.
//

import SwiftUI

struct ContentView: View {
    @State private var user :GithubUser?
    var body: some View {
        VStack (spacing :20){
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                       image
                           .resizable()  // Ensures the image can resize within the frame
                           .aspectRatio(contentMode: .fit)
                           .clipShape(Circle())
                   } placeholder: {
                       Circle()
                           .foregroundColor(.secondary)
                           .aspectRatio(contentMode: .fit)
                   }
                   .frame(width: 120, height: 120)
            Text(user?.login ?? "Username")
                .bold()
                .font(.title3)
            VStack(alignment: .leading, spacing: 20){
                Text(user?.bio ?? "This is where the github bio will go, Lets make it long so it spann for two linnnes......! ")
                Text("Name:  \(user?.name ?? "" )")
                Text("Company:  \(user?.company ?? "Siddhatech" )")
                Text("location:  \(user?.location ?? "" )")
            }
            Spacer()
        }
        .padding()
        .task {
            do{
                user = try await getUser()
            }catch GHError.invalidUrl{
                print("Unable to Fetch Process")
            
            }
            catch GHError.invalidData{
                print("Unable to Fetch")
            
            }catch GHError.invalidResponse{
                print("Unable")
            
            }catch{
                print("unexpected Error")
            }
        }
    }
    func getUser() async throws -> GithubUser {
        let endpoint = "https://api.github.com/users/SangaleBhushan"
        
        guard let url = URL(string: endpoint) else {
            throw GHError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GithubUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }

}

#Preview {
    ContentView()
}




enum GHError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}

struct GithubUser: Decodable {
    let login: String
    let id: Int
    let avatarUrl: String
    let htmlUrl: String
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let bio: String?
    let publicRepos: Int
    let followers: Int
    let following: Int
}

func getUser() async throws -> GithubUser {
    let endpoint = "https://api.github.com/users/octocat"
    
    guard let url = URL(string: endpoint) else {
        throw GHError.invalidUrl
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw GHError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(GithubUser.self, from: data)
    } catch {
        throw GHError.invalidData
    }
}

// Usage example:
// Task {
//     do {
//         let user = try await getUser()
//         print(user)
//     } catch {
//         print(error)
//     }
// }

