function isDirty = isValueDirty(objectHandler,objectType)
switch objectType
    case 'gain'
        isDirty = 'on';
        return
    case 'filter'
        isDirty = 'on';
        return
    case 'pdRBV'
        isDirty = 'on';
        return
    case 'laserPower'
        isDirty = 'on';
        return
    case 'pw'
        isDirty = 'on';
        return
    case 'numberAverages'
        isDirty = 'on';
        return
    otherwise
end

end

