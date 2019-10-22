//
//  RecordingsListTableViewCell.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 22/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit

class RecordingsListTableViewCell: UITableViewCell, CellConfigurable, NibReusable, NibLoadableView {
    
    
    // MARK: - IBOutlets
    @IBOutlet private weak var recordNameLabel: UILabel!
    @IBOutlet private weak var recordDurationLabel: UILabel!
    
    
    // MARK: - Cell setup
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with viewModel: CellViewModel) {
        if let viewModel = viewModel as? RecordingsListTableViewCellViewModelable {
            recordNameLabel.text = viewModel.recordName
            recordDurationLabel.text = viewModel.recordDuration
        }
    }
}
