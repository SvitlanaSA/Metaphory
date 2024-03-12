//
//  TechniqueSettingViewModel.swift
//  Metaphory
//
//  Created by Svetlana Stegnienko on 07.02.2024.
//

import Foundation

enum MetaphoricalTechniques: String {
    case cTechniqueSettingForDay
    case cTechniqueRequest
    case cTechniqueAchievingGoal
    case cTechniqueStagesofLife
    case cTechniqueHarmoniousRelationships
    case cTechniqueMyFamily
    case cTechniqueHouseofMyFear
    case cTechniqueTimeforChange

    func detailedTitle() -> String {
        return self.rawValue + "Detailed"
    }
}

extension MetaphoricalTechniques: CaseIterable { }
extension MetaphoricalTechniques: Identifiable {
    public var id: Self {
        self
    }
}


class TechniqueSettingViewModel: ObservableObject {

    let techniques = MetaphoricalTechniques.allCases

    @Published var selectedID: MetaphoricalTechniques.ID?

}
