#!/usr/bin/env python
# -*- python -*-
## @package ir
# Convenience definitions for intermediate representation (IR) nodes.
#
# Please report bugs to <adrian@llnl.gov>.
#
# \authors <pre>
# Copyright (c) 2010, Lawrence Livermore National Security, LLC
# Produced at the Lawrence Livermore National Laboratory.
# Written by the Components Team <components@llnl.gov>
# UCRL-CODE-????-???
# All rights reserved.
#
# This file is part of Babel. For more information, see
# http://www.llnl.gov/CASC/components/. Please read the COPYRIGHT file
# for Our Notice and the LICENSE file for ????
# License.
#
# </pre>    \TODO insert License

# SIDL nodes
file_           = 'file'
version         = 'version'
require         = 'require'
from_           = 'from'
import_         = 'import'
package         = 'package'
user_type       = 'user type'
attribute       = 'attribute'
type_attribute  = 'type attribute'
identifier      = 'identifier'
enum            = 'enum'
enumerator      = 'enumerator'
struct          = 'struct'
struct_item     = 'struct_item'
class_          = 'class'
interface       = 'interface'
implements      = 'implements'
implements_all  = 'implements all'
method          = 'method'
method_name     = 'method name'
type_           = 'type'
void            = 'void'
arg             = 'arg'
custom_attribute= 'custom attribute'
custom_attribute_assoc = 'custom attribute assoc'
mode            = 'mode'
primitive_type  = 'primitive type'
array           = 'array'
rarray          = 'rarray'
assertion       = 'assertion'
invariant       = 'invariant'

# Expressions
expr            = 'expression'
fn_eval         = 'fn eval'
var_ref         = 'var ref'
scoped_id       = 'scoped id'
complex_        = 'complex'
value           = 'value'

# additional Proc. IR nodes
function        = 'function'
void            = 'void'
stmt            = 'stmt'
get_struct_item = 'get_struct_item'
set_struct_item = 'set_struct_item'
