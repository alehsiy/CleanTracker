//
//  ProgressBlock.swift
//  CleaningManager
//
//  Created by Boyarkina Anastasiya on 21.08.2025.
//
import UIKit

class ProgressBlock: UIView {

    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    private let homeImageView = UIImageView()
    private let percentageLabel = UILabel()
    private let containerView = UIView()

    let adaptiveBlueWithAlpha = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor.systemBlue.withAlphaComponent(0.2)
        default:
            return UIColor.systemBlue.withAlphaComponent(0.1)
        }
    }

    var progress: Float = 0 {
        didSet {
            updateProgress(progress)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainer()
        setupLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupContainer() {
        containerView.backgroundColor = adaptiveBlueWithAlpha
        containerView.layer.cornerRadius = 16
        containerView.layer.cornerCurve = .continuous
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)

        homeImageView.image = UIImage(systemName: "house.fill")
        homeImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(homeImageView)

        percentageLabel.text = "0% done"
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(percentageLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            homeImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            homeImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -15),
            homeImageView.widthAnchor.constraint(equalToConstant: 34),
            homeImageView.heightAnchor.constraint(equalToConstant: 34),

            percentageLabel.topAnchor.constraint(equalTo: homeImageView.bottomAnchor, constant: 60),
            percentageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            percentageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 8),
            percentageLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -8),
            percentageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    private func setupLayers() {
        trackLayer.strokeColor = UIColor.systemGray2.cgColor
        trackLayer.lineWidth = 14
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        containerView.layer.addSublayer(trackLayer)

        progressLayer.strokeColor = UIColor.systemBlue.cgColor
        progressLayer.lineWidth = 14
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        containerView.layer.addSublayer(progressLayer)
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        createCircularPaths()
    }

    private func createCircularPaths() {
        let center = CGPoint(
            x: containerView.bounds.midX,
            y: containerView.bounds.midY - 15
        )
        let radius: CGFloat = 50

        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -CGFloat.pi / 2,
            endAngle: 3 * CGFloat.pi / 2,
            clockwise: true
        )

        trackLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
    }

    // MARK: - Public Methods
    func updateProgress(_ value: Float) {
        let progressValue = max(0, min(value, 1.0))
        let percentage = Int(progressValue * 100)
        UIView.transition(with: percentageLabel, duration: 0.4, options: .transitionCrossDissolve) {
            self.percentageLabel.text = "\(percentage)% done"
        }

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = CGFloat(progressValue)
        animation.duration = 1.6
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.1, 0.25, 1.0)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        progressLayer.strokeEnd = CGFloat(progressValue)
        progressLayer.add(animation, forKey: "progressAnimation")
    }
}
