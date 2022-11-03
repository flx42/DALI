// Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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

#include "dali/operators/image/remap/remap.h"
#include "dali/operators/image/remap/remap.cuh"

namespace dali::remap {

class RemapGpu : public Remap<GPUBackend> {
  using B = GPUBackend;

 public:
  explicit RemapGpu(const OpSpec &spec) : Remap<B>(spec) {}


  void RunImpl(Workspace &ws) override {
    const auto &input = ws.template Input<B>(0);
    TYPE_SWITCH(input.type(), type2id, InputType, REMAP_SUPPORTED_TYPES, (
    {
      RunImplTyped<InputType>(ws);
    }
    ), DALI_FAIL(make_string("Unsupported input type: ", input.type())))  // NOLINT
  }


 private:
  template<typename InputType>
  void RunImplTyped(Workspace &ws) {
    const auto &input = ws.template Input<B>(0);
    const auto &mapx = ws.template Input<B>(1);
    const auto &mapy = ws.template Input<B>(2);
    auto &output = ws.template Output<B>(0);
    kernels::remap::NppRemapKernel<StorageGPU, InputType> kernel;
    kernels::KernelContext ctx;
    ctx.gpu.stream = ws.stream();

    TensorList<B> mapx_shifted, mapy_shifted;
    mapx_shifted.set_order(ws.stream());
    mapy_shifted.set_order(ws.stream());
    if (shift_pixels_) {
      mapx_shifted.Copy(mapx);
      mapy_shifted.Copy(mapy);
      detail::ShiftPixelOrigin(view<float>(mapx_shifted), shift_value_, scratchpad_, ws.stream());
      detail::ShiftPixelOrigin(view<float>(mapy_shifted), shift_value_, scratchpad_, ws.stream());
    }
    kernel.Run(ctx, view<InputType, 3>(output), view<const InputType, 3>(input),
               view<const float, 2>(shift_pixels_ ? mapx_shifted : mapx),
               view<const float, 2>(shift_pixels_ ? mapy_shifted : mapy),
               {}, {}, make_span(interps_), {});
  }

  dali::kernels::DynamicScratchpad scratchpad_{};
};

DALI_REGISTER_OPERATOR(experimental__Remap, RemapGpu, GPU);

}  // namespace dali::remap
