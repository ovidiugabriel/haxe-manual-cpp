
#pragma once

#include <vector>

#include "String.h"

template<typename T>
class Array {
    std::vector<T> data;
public:

    void push(const T& value) {
        data.push_back(value);
    }

    String toString() const {
        return "[]";
    }
};
