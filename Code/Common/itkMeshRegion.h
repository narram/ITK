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
/*=========================================================================
 *
 *  Portions of this file are subject to the VTK Toolkit Version 3 copyright.
 *
 *  Copyright (c) Ken Martin, Will Schroeder, Bill Lorensen
 *
 *  For complete copyright, license and disclaimer of warranty information
 *  please refer to the NOTICE file at the top of the ITK source tree.
 *
 *=========================================================================*/
#ifndef __itkMeshRegion_h
#define __itkMeshRegion_h

#include "itkRegion.h"
#include "itkObjectFactory.h"
#include "itkNumericTraits.h"

namespace itk
{
/** \class MeshRegion
 * \brief A mesh region represents an unstructured region of data.
 *
 * MeshRegion is an class that represents some unstructured portion or
 * piece of a Mesh. The MeshRegion is described as piece i out of N
 * total pieces.
 *
 * \sa Region
 * \sa ImageRegion
 *
 * \ingroup MeshObjects
 */
class ITKCommon_EXPORT MeshRegion:public Region
{
public:
  /** Standard class typedefs. */
  typedef MeshRegion Self;
  typedef Region     Superclass;

  /** Standard part of all itk objects. */
  itkTypeMacro(MeshRegion, Region);

  /** Constructor.  MeshRegion is a lightweight object and is not reference
   * counted. */
  MeshRegion();

  /** Destructor.  MeshRegion is a lightweight object and is not reference
   * counted. */
  virtual ~MeshRegion();

  /** Return the region type. Meshes are described with unstructured regions. */
  virtual RegionType GetRegionType() const
  { return Superclass::ITK_UNSTRUCTURED_REGION; }

  /** Get the number of regions. */
  unsigned long GetNumberOfRegions() const
  { return m_NumberOfRegions; }

  /** Set the number of regions. */
  void SetNumberOfRegions(unsigned long num)
  {
    if ( ( num >= 1 ) && ( num <= NumericTraits< unsigned long >::max() ) )
              { m_NumberOfRegions = num; } }

  /** Get the current region. */
  unsigned long GetRegion() const
  { return m_Region; }

  /** Set the number of regions. */
  void SetRegion(unsigned long region)
  {
    if ( ( region >= 1 ) && ( region <= NumericTraits< unsigned long >::max() ) )
              { m_Region = region; } }

private:
  // The maximum number of regions possible.
  unsigned long int m_NumberOfRegions;

  // The specified region.
  unsigned long int m_Region;
};
} // end namespace itk

#endif