/*=========================================================================
 *
 *  Copyright Insight Software Consortium
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0.txt
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *=========================================================================*/
#ifndef __itkAnchorCloseImageFilter_h
#define __itkAnchorCloseImageFilter_h

#include "itkAnchorOpenCloseImageFilter.h"

namespace itk
{
template< class TImage, class TKernel >
class ITK_EXPORT AnchorCloseImageFilter:
  public AnchorOpenCloseImageFilter< TImage, TKernel, std::greater< typename TImage::PixelType >,
                                     std::less< typename TImage::PixelType > >

{
public:
  typedef AnchorCloseImageFilter Self;
  typedef AnchorOpenCloseImageFilter< TImage, TKernel, std::greater< typename TImage::PixelType >,
                                      std::less< typename TImage::PixelType > > Superclass;

  typedef SmartPointer< Self >       Pointer;
  typedef SmartPointer< const Self > ConstPointer;

  /** Method for creation through the object factory. */
  itkNewMacro(Self);

protected:
  AnchorCloseImageFilter()
  {
    this->m_Boundary1 = NumericTraits< typename TImage::PixelType >::NonpositiveMin();
    this->m_Boundary2 = NumericTraits< typename TImage::PixelType >::max();
  }
  virtual ~AnchorCloseImageFilter() {}

private:

  AnchorCloseImageFilter(const Self &); //purposely not implemented
  void operator=(const Self &);         //purposely not implemented
};
} // namespace itk

#endif
