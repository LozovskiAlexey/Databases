using System;
using System.Data;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Text;

[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedType(Format.Native,
     IsByteOrdered = true, ValidationMethodName = "ValidatePoint")]
public struct Point : INullable
{
    private bool is_Null;
    private Int32 _x;
    private Int32 _y;

    public bool IsNull
    {
        get
        {
            return (is_Null);
        }
    }

    public static Point Null
    {
        get
        {
            Point pt = new Point();
            pt.is_Null = true;
            return pt;
        }
    }

    public override string ToString()
    {
        if (this.IsNull)
            return "NULL";
        else
        {
            StringBuilder builder = new StringBuilder();
            builder.Append(_x);
            builder.Append(",");
            builder.Append(_y);
            return builder.ToString();
        }
    }

    [SqlMethod(OnNullCall = false)]
    public static Point Parse(SqlString s)
    {
        if (s.IsNull)
            return Null;

        Point pt = new Point();
        string[] xy = s.Value.Split(",".ToCharArray());
        pt.X = Int32.Parse(xy[0]);
        pt.Y = Int32.Parse(xy[1]);

        if (!pt.ValidatePoint())
            throw new ArgumentException("Invalid XY coordinate values.");
        return pt;
    }

    public Int32 X
    {
        get
        {
            return this._x;
        }
        set
        {
            Int32 temp = _x;
            _x = value;
            if (!ValidatePoint())
            {
                _x = temp;
                throw new ArgumentException("Invalid X coordinate value.");
            }
        }
    }

    public Int32 Y
    {
        get
        {
            return this._y;
        }
        set
        {
            Int32 temp = _y;
            _y = value;
            if (!ValidatePoint())
            {
                _y = temp;
                throw new ArgumentException("Invalid Y coordinate value.");
            }
        }
    }

    private bool ValidatePoint()
    {
        if ((_x >= 0) && (_y >= 0))
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    // не будет вызываться для атрибутов NULL
    [SqlMethod(OnNullCall = false)]
    public Double Distance()
    {
        return DistanceFromXY(0, 0);
    }

    [SqlMethod(OnNullCall = false)]
    public Double DistanceFrom(Point pFrom)
    {
        return DistanceFromXY(pFrom.X, pFrom.Y);
    }

    [SqlMethod(OnNullCall = false)]
    public Double DistanceFromXY(Int32 iX, Int32 iY)
    {
        return Math.Sqrt(Math.Pow(iX - _x, 2.0) + Math.Pow(iY - _y, 2.0));
    }
}