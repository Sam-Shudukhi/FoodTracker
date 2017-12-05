//
//  RatingControl.swift
//  FoodTracker1
//
//  Created by Hussam Alshudukhi on 2017-01-23.
//  Copyright © 2017 Hussam Alshudukhi. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    
    //MARK: Properties
    
    
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            
            updateButtonSelectionStates()
        }
    }
    
  
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            
            setupButtons()
        }
    }
    
    //MARK: Initialization
    
    
    // Placeholders
    
    override init(frame: CGRect) {
        
        // Call to the superclass's initializer
        
        super.init(frame: frame)
        
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        
        // Call to the superclass's initializer
        
        super.init(coder: coder)
        
        setupButtons()
    }
    
    //MARK: Button Action
    
    func ratingButtonTapped(button: UIButton) {
        
        guard let index = ratingButtons.index(of: button) else {
            
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        
        // Count the number of selected stars by the user
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            
            // Double click on same selected star unrates that meal
            
            rating = 0
        }
        else {
            
            // Meal rating is set to the selected star
            
            rating = selectedRating
        }
        
    }
    
    //MARK: Private Methods
    
    private func setupButtons() {
        
        // remove all old buttons
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
       
        // Load Button Images from the assets catalog. Note that the assets catalog is located in the app’s main bundle
        
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            
            // Create the rating-star buttons
            
            let button = UIButton()
            
//            Set the three states of a rating:
//            Not rated = emptyStar
//            Rated = filledStar
//            On click = highlightedStar
            
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // If there are automatically generated constraints, this code in activates them. It Switches to true once programmatically instantiated and provides the right frame and constraints size
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            // Here the 2 calls define the height & width of the rating buttons. The anchors are used to set the right constraints for the button. Then the constraints are added to the view, then are activated
            
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // The accessibility label is set
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    // This method is to update the rating buttons based on user selection
   
    private func updateButtonSelectionStates() {
        
        for (index, button) in ratingButtons.enumerated() {
            
            // Fill all stars positioned before the selected star
            
            button.isSelected = index < rating
            
            // hintString takes the value of the selected star
            let hintString: String?
            
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            }
            else {
                hintString = nil
            }
            
            // Get the right value string
            let valueString: String
            
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) star set"
            }
            
            // The accessability of hint and value are set to hintString and valueString, respectively
            
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
