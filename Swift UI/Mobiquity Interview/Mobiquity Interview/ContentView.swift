//
//  ContentView.swift
//  Mobiquity Interview
//
//  Created by Brett Ohland on 12/10/19.
//  Copyright © 2019 Mobiquity Inc. All rights reserved.
//

import LaunchKit
import SwiftUI

struct ContentView: View {

    @State private var launches = [LaunchKit.Launch]()

    let numberOfLaunches = 20

    func updateLaunches() {
        LaunchKit.API.getLaunches(numberOfLaunches: numberOfLaunches, { result in
            switch result {
            case let .success(launches):
                self.launches = launches
            case let .failure(error):
                print(error.localizedDescription)
            }
        })
    }

    var body: some View {
        NavigationView {
            MasterView(launches: $launches)
                .onAppear(perform: updateLaunches)
                .navigationBarTitle(Text("Launches into space"))
                .navigationBarItems(
                    trailing: Button(
                        action: updateLaunches,
                        label: {
                            Image(systemName: "arrow.clockwise.circle.fill")
                        }
                    )
                )
            DetailView()
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @Binding var launches: [LaunchKit.Launch]

    var body: some View {
        List {
            ForEach(launches, id: \.self) { launch in
                NavigationLink(
                    destination: DetailView(selectedLaunch: launch)
                ) {
                    Text("\(launch.name)")
                }
            }
        }
    }
}

struct DetailView: View {
    var selectedLaunch: LaunchKit.Launch?

    var body: some View {
        List {
            Section(header: Text("Launch Details")) {
                LaunchRow(
                    title: "Name:",
                    detail: selectedLaunch?.name ?? "Unknown"
                )
                LaunchRow(
                    title: "Window Start:",
                    detail: selectedLaunch?.windowstart ?? "Unknown"
                )
                LaunchRow(
                    title: "Window End:",
                    detail: selectedLaunch?.windowend ?? "Unknown"
                )
                LaunchRow(
                    title: "Net:",
                    detail: selectedLaunch?.net ?? "Unknown"
                )
            }
            Section(header: Text("Rocket Details")) {
                LaunchRow(
                    title: "Name:",
                    detail: selectedLaunch?.rocket.name ?? "Unknown"
                )
                LaunchRow(
                    title: "Configuration:",
                    detail: selectedLaunch?.rocket.configuration ?? "Unknown"
                )
                LaunchRow(
                    title: "Family Name:",
                    detail: selectedLaunch?.rocket.familyname ?? "Unknown"
                )
            }

            ForEach(selectedLaunch?.missions ?? [], id: \.self) { mission in
                Section(header: Text("Mission")) {
                    LaunchRow(
                        title: "Name:",
                        detail: mission.name
                    )
                    LaunchRow(
                        title: "Description:",
                        detail: mission.description
                    )
                    LaunchRow(
                        title: "Mission Type:",
                        detail: mission.typeName
                    )
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("Launch Details"))
    }

    struct LaunchRow: View {
        var title: String
        var detail: String

        var body: some View {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Font.system(size: 11))
                    .fontWeight(.bold)
                    .frame(width: 100, height: nil, alignment: .topLeading)
                Text(detail)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
