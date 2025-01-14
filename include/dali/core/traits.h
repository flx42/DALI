// Copyright (c) 2018-2019, NVIDIA CORPORATION. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef DALI_CORE_TRAITS_H_
#define DALI_CORE_TRAITS_H_

#include <type_traits>
#include <array>
#include <vector>

namespace dali {

template <typename T>
struct is_vector : std::false_type {};

template <typename T, typename A>
struct is_vector<std::vector<T, A> > : std::true_type {};

template <typename T>
struct is_std_array : std::false_type {};

template <typename T, size_t A>
struct is_std_array<std::array<T, A> > : std::true_type {};

template <typename T>
using remove_const_t = typename std::remove_const<T>::type;

template <typename T>
using remove_cv_t = typename std::remove_cv<T>::type;

template <bool Value, typename Type = void>
using enable_if_t = typename std::enable_if<Value, Type>::type;

}  // namespace dali

#endif  // DALI_CORE_TRAITS_H_
