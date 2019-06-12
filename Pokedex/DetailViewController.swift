//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Bruno Klein on 08/06/19.
//  Copyright © 2019 CWI Software. All rights reserved.
//

import UIKit

    class DetailViewController: UIViewController{

        @IBOutlet var gradientView: GradientView!
        @IBOutlet weak var imageView: UIImageView!
        
        @IBOutlet weak var pokemonImageViewHeighConstraint: NSLayoutConstraint!
        @IBOutlet weak var pokemonImageViewWidthConstraint: NSLayoutConstraint!
        @IBOutlet weak var pokemonImageViewCenterVerticallyConstraint: NSLayoutConstraint!
        @IBOutlet weak var pokemonImageViewTopConstraint: NSLayoutConstraint!
        @IBOutlet weak var pokemonTypeView: PokemonTypeView!
        
        var pokemon: Pokemon?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.initialConfig()
            
            if let type = pokemon?.types.first {
                self.pokemonTypeView.config(type: type)
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            self.loadPokemonAnimation()
            self.requestPokemon()
        }
        
        func requestPokemon() {
            if let pokemon = self.pokemon{
                let requestMaker = RequestMaker()
                requestMaker.make(withEndpoint: .details(query: pokemon.id)) {
                    (pokemon: Pokemon) in
                    
                    self.animateImagePokemonToTop()
                }
            }
        }
        
        func animateImagePokemonToTop() {
            DispatchQueue.main.async {
                self.pokemonImageViewTopConstraint.priority = UILayoutPriority(rawValue: 999)
                
                self.pokemonImageViewCenterVerticallyConstraint.priority = UILayoutPriority(rawValue: 900)
                
                UIView.animate(withDuration: 1, animations: {
                    self.imageView.alpha = 1
                    
                    self.pokemonImageViewHeighConstraint.constant = 80
                    self.pokemonImageViewWidthConstraint.constant = 80
                    self.view.layoutIfNeeded()
                })
            }
        }
        
        func loadPokemonAnimation() {
            UIView.animate(withDuration: 1, delay: 0, options: [ .repeat, .autoreverse], animations: {
                self.imageView.alpha = 0.2
            })
            
//            UIView.animate(withDuration: 1, animations: {
//                self.imageView.alpha = self.imageView.alpha == 1 ? 0.2 : 1
//            }) { _ in
//              self.loadPokemonAnimation()
//            }
        }
        
        func initialConfig() {
            if let pokemon = self.pokemon {
                self.gradientView.startColor = pokemon.types.first?.color ?? .black
                
                self.gradientView.endColor = pokemon.types.first?.color?.lighter() ?? .white
                
                self.imageView.loadImage(from: pokemon.image)
            }
        }
        @IBAction func dismissAction(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
        }
}
