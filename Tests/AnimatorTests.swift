//
//  Drops
//
//  Copyright (c) 2021-Present Omar Albeik - https://github.com/omaralbeik
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if os(iOS)
import XCTest
@testable import Drops

final class AnimatorTests: XCTestCase {
    func testInitializer() {
        let position = Drop.Position.bottom
        let delegate = TestAnimatorDelegate()
        let animator = Animator(position: position, delegate: delegate)
        
        XCTAssertEqual(animator.position, position)
        XCTAssert(animator.delegate === delegate)
    }
    
    func testInstall() {
        func install(position: Drop.Position) {
            let delegate = TestAnimatorDelegate()
            let animator = Animator(position: position, delegate: delegate)
            
            let view = UIView()
            let container = UIView()
            let context = AnimationContext(view: view, container: container)
            
            animator.install(context: context)
            
            XCTAssertEqual(animator.context?.view, view)
            XCTAssertEqual(animator.context?.container, container)
            
            XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints)
            XCTAssertEqual(container.subviews[0], view)
            XCTAssertEqual(view.superview, container)
            
            var expectedConstraints: [NSLayoutConstraint] = [
                view.centerXAnchor.constraint(equalTo: container.safeAreaLayoutGuide.centerXAnchor),
                view.leadingAnchor.constraint(greaterThanOrEqualTo: container.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                view.trailingAnchor.constraint(lessThanOrEqualTo: container.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                view.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor, constant: animator.bounceOffset)
            ]
            
            switch position {
            case .bottom:
                expectedConstraints += [
                    view.bottomAnchor.constraint(
                        equalTo: container.safeAreaLayoutGuide.bottomAnchor,
                        constant: -animator.bounceOffset
                    )
                ]
            }
            
            for (actual, expected) in zip(view.constraints, expectedConstraints) {
                XCTAssertEqual(actual, expected)
            }
            
            let animationDistance = view.frame.height
            
            switch position {
            case .bottom:
                XCTAssertEqual(view.transform, CGAffineTransform(translationX: 0, y: animationDistance))
            }
        }
        
        install(position: .bottom)
    }
    
}

#endif
