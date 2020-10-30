//
//  BetterStackView.swift
//  UNiDAYS
//
//  Created by John Wilson on 25/02/2020.
//  Copyright © 2020 Danger Barrel. All rights reserved.
//

public enum stackAlignment: Int {
    case center
    case starting
    case ending
    case fill
}

typealias ConstraintPair = (UIView, NSLayoutConstraint)
typealias CustomSpacingPair = (UIView, CGFloat)

class BetterStackView: UIView {
    // Defines which direction the views stack
    var axis: NSLayoutConstraint.Axis = .vertical {
        didSet { refreshLayout() }
    }
    // Determines the alignment and fill behavior of views on the non-stacking axis
    var alignment: stackAlignment = .center {
        didSet { refreshLayout() }
    }
    // Padding between the views and the stack view perimeter
    var margin: CGFloat = 0 {
        didSet { refreshLayout() }
    }
    // Padding between each view in stack view
    var spacing: CGFloat = 0 {
        didSet { refreshLayout() }
    }
    // Switch from left and right constraints to leading and trailing
    var useLeadAndTrail: Bool = false {
        didSet { refreshLayout() }
    }
    
    // view and constraint reference
    fileprivate var allViews = [UIView]()
    fileprivate var arrangedViews = [UIView]()
    fileprivate var hiddenViews = [UIView]()
    fileprivate var arrangedConstraints = [ConstraintPair]()
    fileprivate var containingConstraints = [ConstraintPair]()
    fileprivate var startingConstraint: NSLayoutConstraint?
    fileprivate var endingConstraint: NSLayoutConstraint?
    fileprivate var observations = [NSKeyValueObservation]()
    fileprivate var customSpacings = [CustomSpacingPair]()

    // Computed helper variables
    fileprivate var startingEdge: ALEdge {
        switch axis {
        case .vertical:
            return .top
        default:
            if useLeadAndTrail {
                return .leading
            }
            return .left
        }
    }
    fileprivate var endingEdge: ALEdge {
        switch axis {
        case .vertical:
            return .bottom
        default:
            if useLeadAndTrail {
                return .trailing
            }
            return .right
        }
    }
    fileprivate var startingAlignmentEdge: ALEdge {
        switch axis {
        case .horizontal:
            return .top
        default:
            if useLeadAndTrail {
                return .leading
            }
            return .left
        }
    }
    fileprivate var endingAlignmentEdge: ALEdge {
        switch axis {
        case .horizontal:
            return .bottom
        default:
            if useLeadAndTrail {
                return .trailing
            }
            return .right
        }
    }
    fileprivate var containingDimension: ALDimension {
        switch axis {
        case .horizontal:
            return .height
        default:
            return .width
        }
    }
    
    func refreshLayout() {
        let views = allViews
        self.removeAllArrangedViews()
        for view in views {
            self.addArrangedSubview(view)
        }
    }
    
    func addArrangedSubview(_ view: UIView) {
        if !view.isHidden {
            self.addSubview(view)
            if let lastView = arrangedViews.last, let endingConstraint = endingConstraint {
                var lastOffset = spacing
                if let customSpacing = self.hasCustomSpacing(lastView) {
                    lastOffset = customSpacing
                }
                
                endingConstraint.isActive = false
                lastView.removeConstraint(endingConstraint)
                let newConstraint = view.autoPinEdge(startingEdge, to: endingEdge, of: lastView, withOffset: lastOffset)
                arrangedConstraints.append((view, newConstraint))
            } else {
                let startingConstraint = view.autoPinEdge(toSuperviewEdge: startingEdge, withInset: margin)
                self.startingConstraint = startingConstraint
                arrangedConstraints.append((view, startingConstraint))
            }
            
            alignView(view)
            
            var endInset = margin
            if let customSpacing = self.hasCustomSpacing(view) {
                endInset = customSpacing
            }
            
            let endingConstraint = view.autoPinEdge(toSuperviewEdge: endingEdge, withInset: endInset)
            self.endingConstraint = endingConstraint
            arrangedConstraints.append((view, endingConstraint))

            let containingConstraint = self.autoMatch(containingDimension, to: containingDimension, of: view, withOffset: margin * 2.0, relation: .greaterThanOrEqual)
            containingConstraints.append((view, containingConstraint))
            
            arrangedViews.append(view)
        } else {
            self.hiddenViews.append(view)
        }
        
        self.allViews.append(view)

        let observation = view.observe(\UIView.isHidden, options: [.old, .new]) { (view, valueChange) in
            if let old = valueChange.oldValue, let new = valueChange.newValue, old == new {
                return
            }
            
            self.updateConstraints(forView: view)
        }
        
        observations.append(observation)
    }
    
    func alignView(_ view: UIView) {
        switch alignment {
        case .starting:
            view.autoPinEdge(toSuperviewEdge: startingAlignmentEdge, withInset: margin)
        case .ending:
            view.autoPinEdge(toSuperviewEdge: endingAlignmentEdge, withInset: margin)
        case .fill:
            view.autoPinEdge(toSuperviewEdge: startingAlignmentEdge, withInset: margin)
            view.autoPinEdge(toSuperviewEdge: endingAlignmentEdge, withInset: margin)
        default:
            switch axis {
            case .vertical:
                view.autoAlignAxis(toSuperviewAxis: .vertical)
                view.autoMatch(.width, to: .width, of: self, withOffset: margin * 2.0, relation: .lessThanOrEqual)
            default:
                view.autoAlignAxis(toSuperviewAxis: .horizontal)
                view.autoMatch(.height, to: .height, of: self, withOffset: margin * 2.0, relation: .lessThanOrEqual)
            }
        }
    }
    
    func updateConstraints(forView view: UIView) {
        refreshLayout()
    }
        
    func removeArrangedView(_ view: UIView) {
        self.removeCustomSpacing(view)
        self.arrangedViews.removeAll(where: { (existing) -> Bool in
            view == existing
        })
        self.arrangedConstraints.removeAll(where: { (existing) -> Bool in
            existing.0 == view
        })
        self.containingConstraints.removeAll(where: { (existing) -> Bool in
            existing.0 == view
        })
        refreshLayout()
    }
    
    func removeAllArrangedViews() {
        for view in arrangedViews {
            view.removeFromSuperview()
        }
        allViews.removeAll()
        arrangedViews.removeAll()
        hiddenViews.removeAll()
        arrangedConstraints.removeAll()
        containingConstraints.removeAll()
        observations.removeAll()
        
        startingConstraint?.isActive = false
        startingConstraint = nil
        endingConstraint?.isActive = false
        endingConstraint = nil
    }
    
    func setCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) {
        removeCustomSpacing(arrangedSubview)
        self.customSpacings.append((arrangedSubview, spacing))
        refreshLayout()
    }

    func customSpacing(after arrangedSubview: UIView) -> CGFloat {
        guard let customSpacing = hasCustomSpacing(arrangedSubview) else {
            return spacing
        }
        return customSpacing
    }
    
    func hasCustomSpacing(_ view: UIView) -> CGFloat? {
        for pair in customSpacings {
            if pair.0 == view {
                return pair.1
            }
        }
        return nil
    }
    
    func removeCustomSpacing(_ view: UIView) {
        customSpacings.removeAll { (pairView, _) -> Bool in
            pairView == view
        }
    }
}
