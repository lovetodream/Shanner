//
//  DocumentTitleView.swift
//  Shanner
//
//  Created by Timo Zacherl on 06.05.22.
//

import UIKit

class DocumentTitleView: UIView {
    lazy var labelView: UILabel = {
        var titleView = UILabel()
        return titleView
    }()

    lazy var buttonView: UIButton = {
        let image = UIImage(systemName: "pencil")
        var buttonConfiguration = UIButton.Configuration.borderless()
        buttonConfiguration.buttonSize = .small
        buttonConfiguration.image = image
        return UIButton(configuration: buttonConfiguration)
    }()

    init(title: String?) {
        super.init(frame: .zero)
        labelView.text = title

        let stackView = UIStackView(arrangedSubviews: [labelView, buttonView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        layoutIfNeeded()
    }

    required init?(coder: NSCoder) {
        fatalError("\(#function) is not implemented")
    }
}
