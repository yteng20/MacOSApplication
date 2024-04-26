//
//  DietView.swift
//  FitnessTracker
//
//  Created by Yue Teng on 4/24/24.
//

import SwiftUI

struct DietView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        VStack {
            Text("Diet")
                .font(.title)

            HStack {
                TextField("Food Name", text: $viewModel.foodName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Calories", text: $viewModel.caloriesText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Add Food") {
                    viewModel.addFood()
                }
                .padding()
                .cornerRadius(10)
            }
            
            List {
                ForEach(viewModel.foods) { food in
                    HStack {
                        Text(food.name)
                        Spacer()
                        Text("\(food.calories) calories")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .cornerRadius(10)

            if !viewModel.foods.isEmpty {
                PieChart(data: viewModel.foods.map { Double($0.calories) }, colors: [.red, .green, .blue, .orange, .purple])
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
            }

            Text("Workout")
                .font(.title)
                .padding()
                .background(Color.orange.opacity(0.3))
                .cornerRadius(5)
        }
        .padding()
        .frame(minWidth: 300)
    }
}
