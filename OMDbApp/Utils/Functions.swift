//
//  Functions.swift
//  OMDbApp
//
//  Created by Mikolaj Kmita on 27/02/2021.
//

import Foundation

func removeDuplicates<T: Equatable>(accumulator: [T], value: T) -> [T] {
    accumulator.contains(value) ? accumulator : accumulator + [value]
}
