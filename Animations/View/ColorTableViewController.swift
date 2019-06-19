//
//  ColorTableViewController.swift
//  AnimationSample
//
//  Created by Hank.Lee on 17/06/2019.
//  Copyright © 2019 Kakao corp. All rights reserved.
//

import UIKit

class ColorTableViewController: UITableViewController {
    var colors: [UIColor] = [.blue, .red, .yellow, .magenta, .purple]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ColorCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ColorCell
        cell.color = colors[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = ColorHeaderTableViewController(color: colors[indexPath.row])
        
        let cell = tableView.visibleCells.first(where: { (cell) -> Bool in
            return tableView.indexPath(for: cell)?.row == indexPath.row
        }) as? ColorCell
        
        viewController.colorTableViewController = self
        viewController.presentingAnimationController = ExpandViewControllerAnimationController(viewCollapsed: cell!.colorView, viewExpanded: viewController.headerView!, duration: 0.4)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    class ColorCell: UITableViewCell {
        var color: UIColor! {
            didSet {
                bind()
            }
        }
        let colorView = UIView()
        let label = UILabel()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            colorView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(colorView)
            colorView.addConstraints([
                NSLayoutConstraint(item: colorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 30),
                NSLayoutConstraint(item: colorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 30)
                ])
            contentView.addConstraints([
                colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                colorView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
                colorView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5),
                ])
            
            label.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(label)
            contentView.addConstraints([
                label.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10),
                label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                label.centerYAnchor.constraint(equalTo: colorView.centerYAnchor)
                ])
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func bind() {
            colorView.backgroundColor = color
            label.text = "\(color!)"
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            bind()
        }
        
        override func setHighlighted(_ highlighted: Bool, animated: Bool) {
            super.setHighlighted(highlighted, animated: animated)
            bind()
        }
    }
}

class ColorHeaderTableViewController: UITableViewController, UIViewControllerAnimationControllerLoadable {
    var item: UIColor
    var interactionController: UIPercentDrivenInteractiveTransition? {
        didSet {
            (dismissingAnimationController as? CollapseViewControllerAnimationController)?.interactionController = interactionController
        }
    }
    
    var headerView: UIView? {
        if !isViewLoaded {
            loadViewIfNeeded()
        }
        return tableView.tableHeaderView
    }
    
    var presentingAnimationController: UIViewControllerAnimatedTransitioning?
    var dismissingAnimationController: UIViewControllerAnimatedTransitioning?
    
    weak var colorTableViewController: ColorTableViewController?
    
    init(color: UIColor) {
        self.item = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setDismissingAnimationController()
    }
    
    private func setDismissingAnimationController() {
        dismissingAnimationController = nil
        
        guard
            let colorTableViewController = colorTableViewController,
            let tableView = colorTableViewController.tableView,
            let cells = tableView.visibleCells as? [ColorTableViewController.ColorCell] else {
                return
        }
        
        guard let viewCollapsed = cells.first(where: { $0.color == item })?.colorView else { return }
        
        let collapseViewControllerAnimationController = CollapseViewControllerAnimationController(viewCollapsed: viewCollapsed, viewExpanded: headerView!, duration: 0.4)
        dismissingAnimationController = collapseViewControllerAnimationController
    }
    
    func setHeaderView() {
        let headerView = UIView()
        headerView.backgroundColor = item
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 200)
        headerView.autoresizingMask = [.flexibleWidth]
        tableView.tableHeaderView = headerView
        tableView.layoutIfNeeded()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(processPanGesture(gestureRecognizer:)))
        headerView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private var interactionPercentComplete: CGFloat = 0
    
    @objc func processPanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            interactionPercentComplete = 0
            navigationController?.popViewController(animated: true)
        case .changed:
            let translation = gestureRecognizer.translation(in: headerView)
            let percentComplete = translation.y / 300
            // print("percentComplete = \(percentComplete)")
            interactionController?.update(percentComplete)
            interactionPercentComplete = percentComplete
        case .ended:
            if interactionPercentComplete > 0.3 {
                interactionController?.update(1)
                interactionController?.finish()
            } else {
                interactionController?.update(0)
                interactionController?.cancel()
            }
            interactionController = nil
        case .cancelled:
            interactionController?.update(0)
            interactionController?.cancel()
            interactionController = nil
        default:
            break
        }
    }
}

class ExpandViewControllerAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var viewCollapsed: UIView
    var viewExpanded: UIView
    var duration: TimeInterval
    
    init(viewCollapsed: UIView, viewExpanded: UIView, duration: TimeInterval) {
        self.viewCollapsed = viewCollapsed
        self.viewExpanded = viewExpanded
        self.duration = duration
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        toView.alpha = 0
        toView.frame = finalFrame
        containerView.addSubview(toView)
        
        let snapshotView = viewCollapsed.snapshotView(afterScreenUpdates: false)!
        let frame = viewCollapsed.superview!.convert(viewCollapsed.frame, to: containerView)
        snapshotView.frame = frame
        containerView.addSubview(snapshotView)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: self.duration - 0.1, animations: {
                let viewExpanded = self.viewExpanded
                let frame = viewExpanded.superview!.convert(viewExpanded.frame, to: containerView)
                snapshotView.frame = frame
            })
            
            UIView.addKeyframe(withRelativeStartTime: self.duration - 0.1, relativeDuration: 0.1, animations: {
                toView.alpha = 1
            })
        }, completion: { (finished) in
            snapshotView.removeFromSuperview()
            let didComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(didComplete)
        })
    }
}

class CollapseViewControllerAnimationController: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerIntractionControllerLoadable {
    var viewCollapsed: UIView
    var viewExpanded: UIView
    var duration: TimeInterval
    var interactionController: UIViewControllerInteractiveTransitioning?
    
    init(viewCollapsed: UIView, viewExpanded: UIView, duration: TimeInterval) {
        self.viewCollapsed = viewCollapsed
        self.viewExpanded = viewExpanded
        self.duration = duration
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        toView.frame = finalFrame
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        let snapshotView = viewExpanded.snapshotView(afterScreenUpdates: false)!
        let frame = viewExpanded.superview!.convert(viewExpanded.frame, to: containerView)
        snapshotView.frame = frame
        containerView.addSubview(snapshotView)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: self.duration - 0.1, animations: {
                let viewCollapsed = self.viewCollapsed
                let frame = viewCollapsed.superview!.convert(viewCollapsed.frame, to: containerView)
                snapshotView.frame = frame
                fromView.alpha = 0
            })
        }, completion: { (finished) in
            let didComplete = !transitionContext.transitionWasCancelled
            snapshotView.removeFromSuperview()
            if didComplete { fromView.removeFromSuperview() }
            transitionContext.completeTransition(didComplete)
        })
    }
}
