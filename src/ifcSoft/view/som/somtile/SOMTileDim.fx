/**
 *  Copyright (C) 2011  Kyle Thayer <kyle.thayer AT gmail.com>
 *
 *  This file is part of the IFCSoft project (http://ifcsoft.com)
 *
 *  IFCSoft is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package ifcSoft.view.som.somtile;

import ifcSoft.view.som.SOMTile;
import java.lang.UnsupportedOperationException;

/**
 * @author kthayer
 */

public class SOMTileDim extends SOMTile{

  public-init var dim:Integer = -1; //-1 is not a dense map, 0 is the main one, above are the subset ones

    override public function updateDenseMap () : Void {
    var cellVals = somMaps.mediator.getDimCellVals();
    if(cellVals == null){
      setBottomText("");
    }else{
      setBottomText("{somMaps.mediator.getDimCellVals()[dim]}");
    }
    }

    override public function updateClusterStats () : Void {
    setBottomText("{somMaps.mediator.getDimClusterVals()[dim] as Float}");
    }

    override public function updatePointStats () : Void {
    var cellVals = somMaps.mediator.getDimCellVals();
    if(cellVals == null){
      setBottomText("");
    }else{
      setBottomText("{somMaps.mediator.getDimCellVals()[dim]}");
    }
    }


}
