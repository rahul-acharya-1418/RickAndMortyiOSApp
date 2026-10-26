//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 09/10/26.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation)
}

class RMSearchView: UIView {
    
    weak var delegate: RMSearchViewDelegate?
    
    private let viewModel: RMSearchViewViewModel
    
    // MARK: - Subviews
    
    private let searchInputView = RMSearchInputView()
    
    private let noResultView = RMNoSearchResultsView()
    
    private let resultView = RMSearchResultView()
    
    // Results collectionView
    
    // MARK: - Init
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(resultView, noResultView, searchInputView)
        addConstraints()
        searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        setUpHandlers()
        
        resultView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpHandlers() {
        viewModel.registerOptionChangeBlock { tuple in
            print(String(describing: tuple))
            self.searchInputView.update(
                option: tuple.0,
                value: tuple.1
            )
        }
        
        viewModel.registerSearchResultHandler { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.resultView.configure(with: result)
                self.noResultView.isHidden = true
                self.resultView.isHidden = false
            }
        }
        
        viewModel.registerNoSearchResultHandler { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.noResultView.isHidden = false
                self.resultView.isHidden = true
            }
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            // Search Input view
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
            
            resultView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultView.leftAnchor.constraint(equalTo: leftAnchor),
            resultView.rightAnchor.constraint(equalTo: rightAnchor),
            resultView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // No results
            noResultView.widthAnchor.constraint(equalToConstant: 150),
            noResultView.heightAnchor.constraint(equalToConstant: 150),
            noResultView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
}

// MARK: - CollectionView

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension RMSearchView: RMSearchInputViewDelegate {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }
    
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
}


extension RMSearchView: RMSearchResultViewDelegate {
    func rmSearchResultView(_ resultsView: RMSearchResultView, didTapLocationAt index: Int) {
        print("Location tapped")
        guard let locationModel = viewModel.locationSearchResult(at: index) else {
            return
        }
        delegate?.rmSearchView(self, didSelectLocation: locationModel)
    }
}
