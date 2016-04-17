//
//  ActividadesCell.swift
//  AppVidaSaludable
//
//  Created by RicardoTrevino on 4/17/16.
//  Copyright © 2016 RicardoTrevino. All rights reserved.
//

import UIKit

class ActividadesCell: UITableViewCell {

    @IBOutlet weak var imView: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblHora: UILabel!
    @IBOutlet weak var lblDias: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
