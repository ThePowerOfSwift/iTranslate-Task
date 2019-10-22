//
//  AppCoordinator.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 20/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import Foundation


final class AppCoordinator: Coordinator<Any> {
    
    lazy var homeCoordinator: HomeCoordinator = {
        return HomeCoordinator(router: router, services: services)
    }()
        
    private let services: AppServices
    
    init(router: RouterType, services: AppServices) {
        self.services = services
        super.init(router: router)
        router.setRootModule(homeCoordinator, hideBar: true)
        addChild(homeCoordinator)
    }
}

