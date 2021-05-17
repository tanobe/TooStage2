//
//  TutorialView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/01/27.
//

import SwiftUI
import UIKit

struct PageViewController<Page: View>: UIViewControllerRepresentable {
    var pages: [Page]

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        return pageViewController
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [context.coordinator.controllers[0]], direction: .forward, animated: true)
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource {
        var parent: PageViewController
        var controllers = [UIViewController]()

        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            controllers = parent.pages.map { UIHostingController(rootView: $0) }
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController?
        {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return controllers.last
            }
            return controllers[index - 1]
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController?
        {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == controllers.count {
                return controllers.first
            }
            return controllers[index + 1]
        }
    }
}

struct TutorialView<Page: View>: View {
    var pages: [Page]

    var body: some View {
        VStack {
            PageViewController(pages: pages)
        }
        .ignoresSafeArea()
    }
}

struct TutorialImageView: View {
    var image: Image
    var body: some View {
        ZStack(alignment: .center) {
            Color("tutorialBack").ignoresSafeArea()
            if image == Image("tutorial5") {
                image
                    .resizable()
                    .scaledToFit()
                VStack {
                    Text("アプリの詳しい使い方\nはこちらのサイトから")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    Link(destination: URL(string: "https://too-toost.studio.site")!) {
                        Text("ホームページ")
                            .fontWeight(.semibold)
                            .font(.subheadline)
                            .foregroundColor(Color("tutorialBack"))
                            .padding(.horizontal, 38)
                            .padding(.vertical, 20)
                            .frame(width: 164, height: 60)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                }
                .offset(y: 30)
            } else {
                image
                    .resizable()
                    .scaledToFit()
                    .offset(y: 30)
            }
        }
    }
}
