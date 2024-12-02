/**
 * some utils function
 */


/**
 * 非空验证
 * param [string | string[]]
 * return [boolean false 未通过 true 通过]
 */
export const nonNullValidation =  (params:string|string[]):boolean => {
  let validation:boolean = false
  if ( typeof params === 'object' && Array.isArray(params)) {
    params.forEach(item=>{
      validation = item===''?false:true
    })
  }else{
    validation = params===''?false:true
  }
  return validation
}